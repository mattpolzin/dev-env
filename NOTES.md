
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
 - For unauthenticated network, `set_network 0 key_mgmt NONE`, visit `8.8.8.8` in browser get redirected to terms page.

Use `nbtscan` to scan for other devices on network; e.g. `nbtscan
192.168.1.50-60`

