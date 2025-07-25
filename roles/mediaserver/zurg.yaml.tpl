zurg: v1
token: <TOKEN>
# host: "[::]"
# port: 9999
# username:
# password:
# proxy:
# concurrent_workers: 20
check_for_changes_every_secs: 10
# repair_every_mins: 60
# ignore_renames: false
# retain_rd_torrent_name: false
# retain_folder_name_extension: false
enable_repair: true
auto_delete_rar_torrents: true
# api_timeout_secs: 15
# download_timeout_secs: 10
# enable_download_mount: false
# rate_limit_sleep_secs: 6
# retries_until_failed: 2
# network_buffer_size: 4194304 # 4MB
# serve_from_rclone: false
# verify_download_link: false
# force_ipv6: false
#on_library_update: sh plex_update.sh "$@"

directories:
  shows:
    group_order: 20
    group: media
    filters:
      - has_episodes: true

  movies:
    group_order: 30
    group: media
    only_show_the_biggest_file: true
    filters:
      - regex: /.*/
