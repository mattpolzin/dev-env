# don't load autoconfig, that file is not being used because qutebrowser will
# attempt to write to it at runtime.
config.load_autoconfig(False)

c.colors.webpage.darkmode.enabled = True
c.fonts.default_size = "16pt"
c.zoom.default = "150%"
c.auto_save.interval = 15000000
c.content.unknown_url_scheme_policy = "allow-from-user-interaction"

with config.pattern('*.slack.com') as p:
    p.content.unknown_url_scheme_policy = "allow-all"
