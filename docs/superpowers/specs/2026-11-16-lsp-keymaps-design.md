# LSP 키맵 정리: `gr`을 순수 접두사로

## 의도

`gr`을 누르면 which-key에 하위 키(코드 액션 `gra` 등)가 보이길 원한다.
지금은 직접 만든 `gr`(references)이 실행 동작이면서 Neovim 0.12 기본 키
`grn`/`gra`/`grr`/`gri`/`grt`/`grx`의 접두사이기도 해서, 팝업이 안 뜨거나
`timeoutlen`만큼 입력이 지연된다.

원인 추정의 근거: which-key는 "동작이면서 접두사인 키"를 `timeoutlen`/`nowait`로
예외 처리한다(`state.lua`의 주석). which-key 소스 전체는 읽지 못해서 확정은 아니다.

## 목표 / 비목표 / 안티골

- 목표
  - `gr`이 전역 매핑 없는 순수 접두사가 되어, 누르면 기본 `gr*` 키가 which-key에 뜬다.
  - `gd`, `gy`, `gI`는 같은 동작으로 유지하되, LSP가 붙은 버퍼에서만 걸린다.
- 비목표
  - 새 `<leader>` 키(포맷, 진단 팝업, 인레이 힌트 토글 등). 필요해지면 후속 작업.
  - 서버 목록, 인레이 힌트, reference highlight, which-key, trouble, aerial 설정 변경.
- 안티골
  - 기존 `gd`/`gy`/`gI` 동작이 달라지면 실패.
  - 새로 외워야 하는 키가 생기면 실패(references는 기본 `grr`를 쓴다).

## 접근

1. **`gr`을 순수 접두사로 되돌리기: 채택.** 말씀하신 문제를 그대로 해결하고
   입력 지연도 없앤다. 새 키가 없다.
2. `<leader>c` 그룹 추가(`ca`/`cr`/`cf`/`cd`/`ch`): 보류. 같은 기능에 키가 두 벌이 된다.
   `gra`가 번거롭게 느껴지면 1번 위에 얹는다.

## 설계

`lua/plugins/lsp.lua` 한 파일만 바꾼다.

- 파일 끝의 전역 `vim.keymap.set` 네 개(`gd`, `gy`, `gI`, `gr`)를 제거한다.
- 새 `LspAttach` autocmd(그룹 `lsp_keymaps`)에서 `gd`, `gy`, `gI`를
  `buffer = args.buf`로 설정한다. desc는 지금 것을 그대로 쓴다.
- `gr` 매핑은 어디에도 만들지 않는다. references는 기본 `grr`이다.
- 기존 reference-highlight용 `LspAttach` autocmd는 건드리지 않는다.

## 확인 방법

- headless: `maparg("gr", "n")`이 빈 문자열이고 `grr`/`gra`가 기본 매핑으로 남아 있는지.
- headless: Lua 파일을 열어 서버가 붙은 뒤 버퍼 로컬 `gd`/`gy`/`gI`가 있는지,
  LSP 없는 버퍼에는 없는지.
- 수동(사용자): `gr`을 눌러 which-key 팝업이 뜨는지. 그래도 안 뜨면 which-key
  쪽을 더 조사한다(원인이 확정이 아니므로).

## 빌더가 정할 부분 (내 결정)

- `gy`/`gI`는 기본 `grt`/`gri`와 겹치지만 손에 익은 키라 유지한다.
- 서버 enable 루프의 들여쓰기는 건드리지 않는다. 새 코드만 파일의 2칸 들여쓰기를 따른다.
