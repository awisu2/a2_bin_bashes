#!/bin/bash

convert_for_browser() {
  local IN="$1"
  local OUT="$2"
  
  # 基本はh264への変換で、ブラウザで再生できるようにする。
  # -c:v libx264: ビデオコーデックをH.264
  # -fflags +genpts: PTS(Presentation Time Stamp)を生成。(ブラウザ互換設定)
  # -pix_fmt yuv420p: ピクセルフォーマットをYUV420pに設定。(ブラウザ互換設定)
  # -profile:v high -level 4.0: H.264のプロファイルとレベルを指定。(ブラウザ互換設定)
  # -movflags +faststart: MP4ファイルのヘッダをファイルの先頭に移動。(ブラウザ互換設定)
  # -c:a aac -b:a 128k: オーディオコーデックをAACに設定し、ビットレートを128kbpsに設定。(ブラウザ互換設定)
  # -avoid_negative_ts make_zero: 負のタイムスタンプをゼロにする。(ブラウザ互換設定)
  ffmpeg -fflags +genpts -i "$IN" \
  -c:v libx264 -pix_fmt yuv420p -profile:v high -level 4.0 \
  -movflags +faststart \
  -c:a aac -b:a 128k \
  -avoid_negative_ts make_zero \
  "$OUT"
}
