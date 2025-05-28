# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

config.load_autoconfig()

c.tabs.background = True
c.new_instance_open_target = 'window'
c.downloads.position = 'bottom'
# c.spellcheck.languages = ['en-US']

config.bind(',ce', 'config-edit')
config.bind(',p', 'config-cycle -p content.plugins ;; reload')

config.bind(',rta', 'open {url}top/?sort=top&t=all')
config.bind(',rtv', 'spawn termite -e "rtv {url}"')
config.bind(',c', 'spawn -d chromium {url}')

# Keyboardio
# config.bind('<Shift-Left>', 'back')
# config.bind('<Shift-Down>', 'tab-next')
# config.bind('<Shift-Up>', 'tab-prev')
# config.bind('<Shift-Right>', 'forward')

# css = '~/proj/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css'
# config.bind(',n', f'config-cycle content.user_stylesheets {css} ""')

c.url.searchengines['rfc'] = 'https://tools.ietf.org/html/rfc{}'
c.url.searchengines['pypi'] = 'https://pypi.org/project/{}/'
c.url.searchengines['qtbug'] = 'https://bugreports.qt.io/browse/QTBUG-{}'
c.url.searchengines['qb'] = 'https://github.com/The-Compiler/qutebrowser/issues/{}'
c.url.searchengines['btc'] = 'https://www.blockchain.com/btc/address/{}'
c.url.searchengines['http'] = 'https://httpstatuses.com/{}'
c.url.searchengines['duden'] = 'https://www.duden.de/suchen/dudenonline/{}'
c.url.searchengines['dictcc'] = 'https://www.dict.cc/?s={}'
#c.url.searchengines['maps'] = 'https://www.google.com/maps?q=%s'

c.aliases['ytdl'] = """spawn -v -m bash -c 'cd ~/vid/yt && youtube-dl "$@"' _ {url}"""

# c.fonts.tabs = '8pt Hack Nerd Font'
c.fonts.statusbar = '10pt Hack Nerd Font'
c.fonts.default_size = '10pt'
c.fonts.completion.entry = '10pt "Hack Nerd Font"'
c.fonts.debug_console = '10pt "Hack Nerd Font"'
c.fonts.prompts = 'default_size Hack Nerd Font'

spacing = {
    "vertical": 5,
    "horizontal": 5
}
padding = {
    "top": spacing["vertical"],
    "right": spacing["horizontal"],
    "bottom": spacing["vertical"],
    "left": spacing["horizontal"],
}

c.statusbar.padding = padding
c.tabs.padding = padding

c.search.incremental = False
c.editor.command = ['code', '-nw', '{}']

#c.qt.args = ['ppapi-widevine-path=/usr/lib/qt/plugins/ppapi/libwidevinecdmadapter.so']

c.content.javascript.enabled = False
# config.source('custom.py')
config.source('custom2.py')
