# LSP 키맵 정리 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `gr`을 순수 접두사로 되돌려 which-key에 `gr*` 기본 키가 뜨게 하고, `gd`/`gy`/`gI`는 LSP가 붙은 버퍼에서만 걸리게 한다.

**Architecture:** `lua/plugins/lsp.lua` 끝의 전역 `vim.keymap.set` 네 개를 지우고, 같은 자리에 `LspAttach` autocmd 하나를 둬서 버퍼 로컬 키 세 개를 건다. references는 Neovim 0.12 기본 `grr`를 쓴다.

**Tech Stack:** Neovim 0.12.6, nvim-lspconfig, lazy.nvim (설정은 `NVIM_APPNAME=nvim_new`로 실행).

**Spec:** `docs/superpowers/specs/2026-11-16-lsp-keymaps-design.md`

## Global Constraints

- 새 코드는 2칸 들여쓰기. 서버 enable 루프(`lsp.lua:167-171`)의 기존 들여쓰기는 건드리지 않는다.
- desc는 그대로: `"Goto Definition"`, `"Goto Type Definition"`, `"Goto Implementation"`.
- 새로 외워야 하는 키를 만들지 않는다. references는 기본 `grr`.
- 기존 reference-highlight용 `LspAttach`(그룹 `lsp_reference_highlight`)와 which-key, trouble, aerial 설정은 건드리지 않는다.
- 새 augroup 이름은 `lsp_keymaps`.

## Review Focus

- LSP가 없는 버퍼(`:enew`)에서 `gd`/`gy`/`gI`가 걸려 있지 않아야 한다. → Task 1 check의 `no-global-*`.
- 한 버퍼에 서버가 둘 붙어도(Python: ruff, ty) 키가 정상이어야 한다. → Task 1 check의 `python-buffer-local`.
- 기본 `gr*`(`grr`, `gra`)는 남아 있어야 한다. → Task 1 check의 `defaults-kept`.

---

### Task 1: `gr` 해제와 버퍼 로컬 이동

**Files:**
- Modify: `lua/plugins/lsp.lua:173-184` (전역 키맵 네 개를 `LspAttach` autocmd 하나로 교체)
- Test: `/private/tmp/claude-501/-Users-hojooneum--config-nvim-new/dff43b20-f3de-4dea-bd66-d7e41f517f6f/scratchpad/check_lsp_keymaps.lua` (저장소 밖 임시 스크립트)

**Interfaces:**
- Produces: augroup `lsp_keymaps`, 버퍼 로컬 normal-mode 매핑 `gd`, `gy`, `gI`.

- [ ] **Step 1: 확인 스크립트를 쓴다.** 위 경로에 `check_lsp_keymaps.lua`를 만들고, 아래 이름의 check가 실패하면 이름을 모아 stdout에 쓴 뒤 `cquit`, 모두 통과하면 `qa!` 한다. Lua 버퍼에서 `vim.wait(10000, ...)`로 클라이언트가 붙기를 기다린 뒤 실행한다.

```lua
-- 서버가 붙은 Lua 버퍼
check("lua-buffer-local", bl("gd") and bl("gy") and bl("gI"))
-- Python 버퍼 (ruff, ty). 같은 스크립트에서 `edit`로 연다.
check("python-buffer-local", bl("gd") and bl("gy") and bl("gI"))
-- LSP 없는 버퍼(:enew)
check("no-global-gd-gy-gI", map("gd") == "" and map("gy") == "" and map("gI") == "")
check("no-global-gr", map("gr") == "")
check("defaults-kept", map("grr") ~= "" and map("gra") ~= "")
-- bl(lhs): vim.fn.maparg(lhs, "n", false, true).buffer == 1
-- map(lhs): vim.fn.maparg(lhs, "n")
```

Python 검사용 샘플은 같은 scratchpad에 `check_sample.py`(`x = 1` 한 줄)로 만든다.

- [ ] **Step 2: 변경 전에 실패하는지 확인한다.**

Run: `cd /Users/hojooneum/.config/nvim_new && NVIM_APPNAME=nvim_new nvim --headless lua/plugins/lsp.lua "+luafile <scratchpad>/check_lsp_keymaps.lua"; echo "exit=$?"`
Expected: `lua-buffer-local`, `python-buffer-local`, `no-global-gd-gy-gI`, `no-global-gr`가 FAIL로 나오고 `exit=1`. `defaults-kept`는 통과.

- [ ] **Step 3: `lsp.lua:173-184`를 교체한다.** 전역 `vim.keymap.set` 네 개를 지우고 같은 자리에 `LspAttach` autocmd(그룹 `lsp_keymaps`, `clear = true`)를 둔다. 콜백은 `gd` → `vim.lsp.buf.definition`, `gy` → `vim.lsp.buf.type_definition`, `gI` → `vim.lsp.buf.implementation`을 `{ buffer = args.buf, desc = ... }`로 normal 모드에 건다. `gr`은 어디에도 만들지 않는다. 한 버퍼에 서버가 여러 번 붙으면 같은 키를 다시 덮어쓰면 된다.

- [ ] **Step 4: 통과하는지 확인한다.**

Run: Step 2와 같은 명령.
Expected: 출력 없이 `exit=0`.

- [ ] **Step 5: 사람이 눈으로 확인한다.** 사용자가 Neovim에서 `gr`을 눌러 which-key 팝업에 `a`/`n`/`r`/`i`/`t`가 뜨는지, `gra`로 코드 액션이 도는지 본다. 안 뜨면 구현은 멈추고 which-key 쪽 조사로 넘어간다(스펙 "확인 방법").

- [ ] **Step 6: 커밋은 사용자가 요청할 때만 한다.** 요청하면 `lua/plugins/lsp.lua`와 아직 커밋 안 된 `docs/superpowers/specs/2026-11-16-lsp-keymaps-design.md`, 이 계획 파일을 한 커밋으로 묶는다. 메시지는 저장소 관례대로 짧은 영어 명령형(예: `Free the gr prefix and attach LSP keymaps per buffer`).
