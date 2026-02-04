vim9script

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
        omniComplete: true,
        outlineWinSize: 30,
        usePopupInCodeAction: false,
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
                    "ignore": ["E501", "E231", "E231", "F405", "F841", "D", "CNL", "Q000", "I100"],
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
    # if executable('perl')
    #   g:LspAddServer([{
    #       name: 'perl',
    #       filetype: ['perl'],
    #       path: '/usr/bin/perl',
    #       args: [
    #         "-MPerl::LanguageServer", "-e", "Perl::LanguageServer::run", "--",
    #         "--debug"
    #       ]
    #         # "--port", "13603", "--nostdio", "0",]
    #   }])
    # endif
    if executable('pls')
      g:LspAddServer([{
        name: 'perl',
        filetype: ['perl'],
        path: '/usr/local/bin/pls',
        args: [],
        workspaceConfig: {
          'pls': {
            'inc': [ '/my/perl/5.34/lib', ],  # add list of dirs to @INC
            #'cwd' = { '/my/projects' },   # working directory for PLS
            'perlcritic': { 'enabled': 1, },  # use perlcritic and pass a non-default location for its config
            'syntax': { 'enabled': 1, 'perl': '/usr/bin/perl', }, # enable syntax checking and use a non-default perl binary
            #'perltidy' = { 'perltidyrc' = '/my/projects/.perltidyrc' } # non-default location for perltidy's config
          },
        },
      }])
    endif
    if executable('awk-language-server')
      g:LspAddServer([{
        name: 'awkls',
        filetype: 'awk',
        path: '/usr/local/bin/awk-language-server',
        args: []
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

