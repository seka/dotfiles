import type {
  ConfigArguments,
  ConfigReturn,
} from "../plugins/repos/github.com/Shougo/dpp.vim/denops/dpp/base/config.ts";
import type { Plugin } from "../plugins/repos/github.com/Shougo/dpp.vim/denops/dpp/types.ts";

// 取得先と固定リビジョンを一か所で指定し、状態生成時に各プラグインの定義へ展開する。
const repositories: [string, string?][] = [
  // プラグイン管理: dpp 本体に installer と Git protocol を組み合わせて取得・更新する。
  ["Shougo/dpp.vim"],
  ["Shougo/dpp-ext-installer"],
  ["Shougo/dpp-protocol-git"],

  // 表示・共通ユーティリティ
  ["altercation/vim-colors-solarized"],
  // Deno で動く dpp / ddc の処理を Vim と接続する共通基盤。
  ["vim-denops/denops.vim"],

  // 補完: ddc が候補を集め、UI・source・filter を組み合わせて表示する。
  ["Shougo/ddc.vim"],
  ["Shougo/ddc-ui-pum"], // pum を ddc の候補表示 UI として接続
  ["Shougo/pum.vim"], // 補完ポップアップの表示・操作
  ["Shougo/ddc-source-lsp"], // LSP から補完候補を取得
  ["Shougo/ddc-source-around"], // 周辺テキストから補完候補を取得
  ["Shougo/ddc-filter-matcher_head"], // 入力の前方一致で候補を絞り込む
  ["Shougo/ddc-filter-sorter_rank"], // 候補を順位に従って並べる
  ["Shougo/neosnippet"], // スニペットの展開・プレースホルダー間の移動
  ["Shougo/neosnippet-snippets"], // neosnippet 用のスニペット定義

  // ターミナル・検索・構文解析
  ["akinsho/toggleterm.nvim"],
  // Telescope が利用する Lua ユーティリティ。
  ["nvim-lua/plenary.nvim"],
  ["nvim-telescope/telescope.nvim"],
  // main に正式タグがないためコミットを固定し、更新時の予期しない API 変更を防ぐ。
  ["nvim-treesitter/nvim-treesitter", "19bdfc04f40ed2ccb3340591d125f759b0406875"],

  // ファイル・バッファ管理と編集支援
  ["Shougo/neomru.vim"],
  ["preservim/nerdtree"],
  ["preservim/nerdcommenter"],
  ["akinsho/bufferline.nvim"],
  ["nvim-tree/nvim-web-devicons"],
  ["mfussenegger/nvim-lint"],
  ["stevearc/conform.nvim"],
  ["tpope/vim-surround"],
  ["tpope/vim-fugitive"],
  ["nvim-lualine/lualine.nvim"],
  ["godlygeek/tabular"],
  ["easymotion/vim-easymotion"],
  ["preservim/tagbar"],
  ["jiangmiao/auto-pairs"],
  ["lukas-reineke/indent-blankline.nvim", "v3.10.1"],
  ["mg979/vim-visual-multi", "v0.5.8"],
  ["editorconfig/editorconfig-vim"],

  // LSP: Mason でサーバーを取得し、nvim-lspconfig の定義で設定する。
  ["mason-org/mason.nvim"],
  ["mason-org/mason-lspconfig.nvim"],
  ["neovim/nvim-lspconfig"],

  // JSON
  ["elzr/vim-json"],

  // HTML
  ["othree/html5.vim"],

  // JavaScript
  ["pangloss/vim-javascript"],
  ["jelera/vim-javascript-syntax"],
  ["moll/vim-node"],
  ["othree/javascript-libraries-syntax.vim"],

  // Go
  ["fatih/vim-go"],

  // Ruby
  ["vim-ruby/vim-ruby"],

  // Python
  ["hdima/python-syntax"],
];

export class Config {
  apiVersion = 2;

  config({ contextBuilder, basePath }: ConfigArguments): ConfigReturn {
    contextBuilder.setGlobal({ protocols: ["git"] });
    const plugins: Plugin[] = repositories.map(([repo, rev]) => ({
      name: repo.split("/").at(-1)!,
      repo,
      path: `${basePath}/repos/github.com/${repo}`,
      rev,
      // Lua モジュールを各プラグインの取得先から直接読み込むため、結合を無効にする。
      merged: false,
    }));
    return { plugins };
  }
}
