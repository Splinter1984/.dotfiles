vim9script

if exists("g:loaded_vimcomplete")
    var dictproperties = {
        python: { sortedDict: false },
        text: { sortedDict: true },
        cpp: { sortedDict: false, onlyWords: false, matchStr: '\S\+$', triggerWordLen: 2, info: false },
        c: { sortedDict: false, onlyWords: false, matchStr: '\S\+$', triggerWordLen: 2, info: false },
        bash: { sortedDict: true },
        sh: { sortedDict: true },
    }
    g:VimCompleteOptionsSet({
        completor: { matchCase: false, triggerWordLen: 0, shuffleEqualPriority: true, alwaysOn: true, postfixClobber: true, postfixHighlight: true, showKind: true, debug: false },
        buffer: { enable: true, maxCount: 5, priority: 10, urlComplete: true, envComplete: true, completionMatcher: 'icase' },
        dictionary: { enable: false, priority: 9, maxCount: 5, filetypes: ['python', 'cpp', 'text'], matcher: 'ignorecase', properties: dictproperties },
        abbrev: { enable: true, maxCount: 30 },
        lsp: { enable: true, maxCount: 5, priority: 11, keywordOnly: false },
        omnifunc: { enable: false, priority: 9, filetypes: ['c', 'tex', 'python'] },
        vsnip: { enable: false, adaptNonKeyword: true, filetypes: ['python', 'cpp'] },
        vimscript: { enable: true, priority: 10 },
        tmux: { enable: false },
        tag: { enable: true },
        path: { enable: true },
        ngram: {
            enable: true,
            priority: 10,
            bigram: false,
            filetypes: ['text', 'help', 'markdown', 'txt'],
            filetypesComments: ['c', 'cpp', 'python', 'lua', 'vim', 'sh', 'bash'],
            triggerWordLen: 2,
        },
    })
    # Map keys to scroll "info" window (doc window)
    inoremap <silent><expr> <Home> g:VimCompleteInfoWindowVisible() ?
                \ (feedkeys("\<Plug>(vimcomplete-info-window-pageup)", 'ni') ? "" : "") : "\<Home>"
    inoremap <silent><expr> <End> g:VimCompleteInfoWindowVisible() ?
                \ (feedkeys("\<Plug>(vimcomplete-info-window-pagedown)", 'ni') ? "" : "") : "\<End>"

    # Remove border from info window (doc window)
    autocmd VimEnter * set completepopup+=border:off,highlight:Normal
    # Set more options (not settable through completepopup)
    g:VimCompleteInfoWindowOptionsSet({
        # borderhighlight: ['Comment'],
        # borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
        # drag: false,
        close: 'none',
        resize: false,
    })
    g:vimcomplete_tab_enable = 1
endif

if exists("g:loaded_lsp")
    g:LspOptionsSet({
        autoHighlight: false,
        autoHighlightDiags: true,
        showDiagWithVirtualText: false, # when you set this false, set showDiagOnStatusLine true
        highlightDiagInline: true,
        showDiagOnStatusLine: true,
        diagVirtualTextAlign: 'after',
        autoPopulateDiags: false, # add diags to location list automatically <- :lopen [l ]l
        # completionMatcher: 'fuzzy', # case/fuzzy/icase
        # diagSignErrorText: ' ',
        # diagSignHintText: ' ',
        # diagSignInfoText: ' ',
        # diagSignWarningText: ' ',
        # outlineWinSize: 30,
        showSignature: true,
        # showInlayHints: true,
        echoSignature: true,
        # vsnipSupport: false,
        ignoreMissingServer: true,
        # autoComplete: false,  # when false, it sets omnifunc (use <c-x><c-o>)
        outlineWinSize: 30
    })
    if executable('clangd')
        g:LspAddServer([{
            name: 'clangd',
            filetype: ['c', 'cpp'],
            path: 'clangd',
            args: ['--background-index', '--header-insertion=never'],
            single_file_support: v:true,
        }])
    endif
    if executable('pylsp')
        g:LspAddServer([{
            name: 'pylsp',
            filetype: ['python'],
            path: exepath('pylsp'),
            args: ['--check-parent-process', '-v'],
            workspaceConfig: {
              "pylsp": {
                "configurationSources": ["jedi", "flake8", "pycodestyle"],
                "plugins": {
                  "flake8": {
                    "enabled": v:true,
                    "exclude": ['.git', '__pycache__', 'build'],
                    "ignore": ["E501", "E231", "E231", "F405", "F841", "D", "CNL", "Q000"],
                    "per-file-ignores": {
                      "__init__.py": "F401"
                    },
                  },
                  "pycodestyle": {
                    "enabled": v:true,
                    "ignore": ["E704", "E302", "E501", "E305"],
                    "max-line-length": 160,
                    "statistics": v:true
                  },
                  "jedi": {
                    "enabled": v:true
                  },
                  # XXX: don't like to disable them fully. maybe need to dig into
                  #      their configurations.
                  # {{{
                    "pyling": {
                      "enabled": v:false
                    },
                    "pyflakes": {
                      "enabled": v:false,
                      "ignore": ["F403"]
                    },
                    "autopep8": {
                      "enabled": v:false
                    },
                    "mccabe": {
                      "enabled": v:false
                    },
                  # }}}
                }
              }
            }
        }])
    endif
    if executable('rust-analyzer')
        g:LspAddServer([{
            name: 'rust-analyzer',
            filetype: ['rust'],
            args: [],
            syncInit: v:true,
            path: exepath('rust-analyzer'),
        }])
    endif
    def LSPUserSetup()
        nnoremap <buffer> [e :LspDiagPrev<CR>| # think as 'error' message
        nnoremap <buffer> ]e :LspDiagNext<CR>
        nnoremap <buffer> K  :LspHover<CR>
        nnoremap <buffer> gD :LspGotoDeclaration<CR>
        nnoremap <buffer> gd :LspGotoDefinition<CR>
        nnoremap <buffer> gI :LspGotoImpl<CR>
        #if &background == 'dark'
        #    highlight  LspDiagVirtualTextError    ctermbg=none  ctermfg=1
        #    highlight  LspDiagVirtualTextWarning  ctermbg=none  ctermfg=3
        #    highlight  LspDiagVirtualTextHint     ctermbg=none  ctermfg=2
        #    highlight  LspDiagVirtualTextInfo     ctermbg=none  ctermfg=5
        #endif
        # highlight  link  LspDiagSignErrorText    LspDiagVirtualTextError
        # highlight  link  LspDiagSignWarningText  LspDiagVirtualTextWarning
        # highlight  link  LspDiagSignHintText     LspDiagVirtualTextHint
        # highlight  link  LspDiagSignInfoText     LspDiagVirtualTextInfo
        # highlight LspDiagInlineWarning ctermfg=none
        # highlight LspDiagInlineHint ctermfg=none
        # highlight LspDiagInlineInfo ctermfg=none
        # highlight LspDiagInlineError ctermfg=none cterm=undercurl
        # highlight LspDiagVirtualText ctermfg=1
        # highlight LspDiagLine ctermbg=none
    enddef
    autocmd User LspAttached LSPUserSetup()
endif

if exists("g:loaded_gitgutter")
  # FIXME: currently not working.
  if exists("#gitgutter")
    #autocmd! gitgutter QuickFixCmdPre *vimgrep*
    #autocmd! gitgutter QuickFixCmdPost *vimgrep*
    autocmd BufWrite * GitGutterAll
  endif
endif

if exists("g:gutentags_enabled")
  g:gutentags_modules = ['ctags', 'gtags_cscope']
  # config project root markers.
  g:gutentags_project_root = ['.root']
  # generate datebases in my cache directory, prevent gtags files polluting my project
  # g:gutentags_cache_dir = expand('~/.cache/tags')
  # resolve all sym links please!
  g:gutentags_resolve_symlinks = 1
  # change focus to quickfix window after search (optional).
  g:gutentags_plus_switch = 1
  g:gutentags_ctags_exclude = ['install', 'build']
endif

if exists("g:loaded_vimsuggest")
    var VimSuggest = {}
    VimSuggest.search = {
        # enable: false,
        alwayson: true,
        # pum: false,
        # trigger: 'tn',
        reverse: false,
        fuzzy: true,
        # prefixlen: 3,
        popupattrs: {
            #borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
            #borderhighlight: ['LineNr'],
            #highlight: 'Normal',
            #border: [1, 1, 1, 1],
            #padding: [1, 1, 1, 1],
            maxheight: 10,
        },
    }
    VimSuggest.cmd = {
        # enable: false,
        alwayson: true,
        # pum: true,
        fuzzy: true,
        # exclude: ['^\s*\d*\s*b\%[uffer]!\?\s\+'],
        # onspace: ['colo\%[rscheme]', 'b\%[uffer]', 'e\%[dit]', 'Scope'],
        # onspace: '.*',
        # trigger: 'tn',
        reverse: true,
        # auto_first: true,  # XXX: :hi will not call ':highlight' but calls ':HighlightGroupUnderCursor'
                             # which cause a E163 error during work with
                             # buffers
        complete_sg: true,
        # prefixlen: 3,
        # bindkeys: false,
        popupattrs: {
            #borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
            #borderhighlight: ['LineNr'],
            #highlight: 'Normal',
            #border: [1, 1, 1, 1],
            #padding: [1, 0, 0, 0],
            maxheight: 20,
        },
    }

    g:VimSuggestSetOptions(VimSuggest)

    augroup vimsuggest-qf-show
        autocmd!
        autocmd QuickFixCmdPost clist cwindow
    augroup END

    # cnoremap <expr> <PageUp> g:VimSuggestMenuVisible() ? "\<Plug>(vimsuggest-pageup)" : "\<PageUp>"
    # cnoremap <expr> <PageDown> g:VimSuggestMenuVisible() ? "\<Plug>(vimsuggest-pagedown)" : "\<PageDown>"
    # cnoremap <Plug>(vimsuggest-dismiss) <Nop>
    # cnoremap <C-e> <Plug>(vimsuggest-dismiss)
    # cnoremap <C-e> <Plug>VimsuggestDismiss;

    # find
    g:vimsuggest_fzfindprg = 'fd --type f .'
    g:vimsuggest_shell = true
    set shell=/bin/sh
    set shellcmdflag=-c
    nnoremap <leader>ff :VSFind<space>
    # nnoremap <leader><space> :VSGitFind<space>
    # nnoremap <leader>fv :VSFind ~/.vim<space>
    # nnoremap <leader>fz :VSFind ~/.zsh/<space>
    nnoremap <leader>fV :VSFind $VIMRUNTIME<space>

    nnoremap <leader>/ :VSGlobal<space>
    nnoremap <leader>; :VSInclSearch<space>

    # live find
    # g:vimsuggest_shell = true
    # g:vimsuggest_findprg = 'fd --type f --glob'
    g:vimsuggest_findprg = 'fd --type f'
    # g:vimsuggest_findprg = 'find -EL $* \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name $*'
    nnoremap <leader>fl :VSFindL "*"<left><left>

    # nnoremap <leader>fF :VSExec fd --type f<space>
    # nnoremap <leader>fF find -EL . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name "*"<left><left>

    # XXX: If you use 'find ~/.zsh', it shows nothing since -path matches whole path and dot dirs (including .zsh) are excluded.
    # nnoremap <leader>ff :VSCmd e find . \! \( -path "*/.*" -prune \) -type f -name "*"<left><left>
    # Live grep (see notes in .zsh dir)
    # nnoremap <leader>g :VSExec ggrep -REIHins "" . --exclude-dir={.git,"node_*"} --exclude=".*"<c-left><c-left><c-left><left><left>
    # NOTE: '**' automatically excludes hidden dirs and files, but it is much slower.
    # nnoremap <leader>g :VSExec grep -IHSins "" **/*<c-left><left><left>
    # XXX '~' does not work with Vim
    # nnoremap <leader>g :VSExec grep -IHins "" . **/*\~node_modules/*<c-left><left><left><left><left>

    # Live grep
    # g:vimsuggest_grepprg = 'ggrep -REIHns $* --exclude-dir=.git --exclude=".*" --exclude="tags"'
    g:vimsuggest_grepprg = 'rg --vimgrep --smart-case $* .'
    # g:vimsuggest_grepprg = 'ag --vimgrep'
    nnoremap <leader>g :VSGrep ""<left>
    nnoremap <leader>G :VSGrep "<c-r>=expand('<cword>')<cr>"<left>
    g:vimsuggest_shell = true  # Needed for '**', {}, etc. shell expansion in VSExec ggrep
    # NOTE: 'x' inside {} below is just a placeholder ({foo} does not work)
    #       VSGrep does not do highlight by default (call AddHighlightHook for highlight)
    nnoremap <leader>vg :VSExec ggrep -REIHns "" --exclude-dir={.git,x} --exclude=".*"<c-left><c-left><left><left>

    noremap  <leader>fb :VSBuffer<space>

    nnoremap <leader>fk :VSKeymap<space>
    nnoremap <leader>fr :VSRegister<space>
    nnoremap <leader>fm :VSMark<space>

    # :find ** -> lists directories     also
    # None of the following can descend into directories correctly
    #
    # with zsh -c, slow
    # nnoremap <leader><space> :VSCmd e find 2>/dev/null **/*(.N)<left><left><left><left><left>
    # nnoremap <leader><space> :VSCmd e find 2>/dev/null **/*~.git/*(.N)<c-left><right><right><right>
    # nnoremap <leader><space> :VSCmd e find **/*(.N)<left><left><left><left><left>
    #
    # dev null needs 'sh -c'
    # 10x faster than "**" solution
    # nnoremap <leader><space> :VSCmd e find . -type f -name "*" 2>/dev/null<c-left><left><left>
    #
    # import autoload 'vimsuggest/extras/vscmd.vim'
    # vscmd.shellprefix = 'sh -c'
    # vscmd.shellprefix = 'zsh -o extendedglob -c'
    #
    # no /dev/null needed if you don't print error
    # nnoremap <leader><space> :VSCmd e find . -path "*/.git" -prune -o -type f -name "*"<left><left>

    # nnoremap <leader><space> :VSCmd e find -E . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name "*"<left><left>

    # import autoload 'vimsuggest/extras/vsfind.vim'
    # var cmdstr = 'find -E . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name'
    # def FindCompletor(context: string, line: string, cursorpos: number): list<any>
    #     return vsfind.Completor(context, line, cursorpos, cmdstr)
    # enddef
    # def FindAction(arg: string)
    #     vsfind.Action('e', cmdstr, arg)
    # enddef
    # command! -nargs=+ -complete=customlist,FindCompletor Find FindAction(<f-args>)
    # nnoremap <leader><space> :Find *<left>

    # command! -nargs=+ -complete=customlist,FindCompletor Find vsfind.DoCommand(<f-args>)
    # nnoremap <leader><space> :Find e "*"<left><left>
    # command! -nargs=1 -complete=customlist,FindCompletor Find FindAction(<f-args>)

    # var grepcmd = 'grep -REIHSins --exclude="{.gitignore,.swp,.zwc,tags,./.git/*}"'
    # grep --color=never -REIHSins --exclude="{.{gitignore,swp,zwc},{tags,./.git/*}}"

    #  grep --color=never -REIHSins --exclude=".gitignore" --exclude="*.swp" --exclude="*.zwc" --exclude="tags" --exclude="./.git/*" a
    # def GrepCompletor(context: string, line: string, cursorpos: number): list<any>
    #     return vsfind.Completor(context, line, cursorpos, grepcmd, 'zsh -c')
    # enddef
    # def GrepAction(arg: string)
    #     vsfind.Action('e', grepcmd, arg)
    # enddef
    # command! -nargs=+ -complete=customlist,FindCompletor Find FindAction(<f-args>)
    # nnoremap <leader>fg :Grep<space>
    #
    # command -nargs=1 Find VSCmd e find -E . \! \( -regex ".*\.(zwc\|swp\|git\|zsh_.*)" -prune \) -type f -name
    # nnoremap <leader><space> :Find "*"<left><left>
    #
    # 'ls' with ** is slow
    # ls lists directories when file glob fails. (N) removes (.) when (.) fails.
    # nnoremap <leader><space> :VSCmd e ls -1 **/*(.N)<left><left><left><left><left>
endif
