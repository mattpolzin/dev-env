
# Linux

## Audio

Use `pamixer` to adjust input, output, volume.

Use `wpctl` for overall status and control of audio and video.

## Bluetooth

Use `rfkill` to unblock bluetooth device.

Use `bluetoothctl` to `power on`, `scan on` or `discovery on`, `pair`,
`connect`, and optionally `trust`.

## Network

Use `wpa_cli` to manage wifi connections manually. `add_network`, `scan`,
`set_network 0 ssid "sdfsdf"`, `enable_network 0`.
 - For unauthenticated networks, `set_network 0 key_mgmt NONE`, visit `8.8.8.8` (most cases) or `http://www.wifilauncher.com` (boingo hotspots) in browser get redirected to terms page.
 - For passphrase networks, `set_network 0 key_mgmt WPA-PSK`, `set_network 0 psk "asdf"`

Use `nbtscan` to scan for other devices on network; e.g. `nbtscan
192.168.1.50-60`

## Images
Use `feh` to view.

Use `evince` for PDFs.
