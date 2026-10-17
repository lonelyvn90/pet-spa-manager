#!/usr/bin/env bash
# Áp icon, màn hình chờ, màu chủ đạo và phiên bản vào project Android do Capacitor tạo ra.
set -euo pipefail
RES=android/app/src/main/res
SRC=resources/android

# 1) Icon app (vuông, tròn, adaptive)
for d in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  cp "$SRC/mipmap-$d/"*.png "$RES/mipmap-$d/"
done
# Nền của icon adaptive = vàng logo
cat > "$RES/values/ic_launcher_background.xml" <<'XML'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#F5D55C</color>
</resources>
XML

# 2) Màn hình chờ khi mở app
find "$RES" -name 'splash.png' -path '*land*' -exec cp "$SRC/splash_land.png" {} \;
find "$RES" -name 'splash.png' ! -path '*land*' -exec cp "$SRC/splash_port.png" {} \;

# 3) Màu thanh trạng thái / thanh tiêu đề
if [ -f "$RES/values/colors.xml" ]; then
  sed -i 's|<color name="colorPrimary">[^<]*</color>|<color name="colorPrimary">#F5D55C</color>|' "$RES/values/colors.xml"
  sed -i 's|<color name="colorPrimaryDark">[^<]*</color>|<color name="colorPrimaryDark">#E9C744</color>|' "$RES/values/colors.xml"
  sed -i 's|<color name="colorAccent">[^<]*</color>|<color name="colorAccent">#E8478B</color>|' "$RES/values/colors.xml"
fi

# 4) Số phiên bản: versionCode tăng theo mỗi lần build trên GitHub để cài đè được
CODE="${GITHUB_RUN_NUMBER:-1}"
NAME="1.0.${CODE}"
sed -i -E "s/versionCode [0-9]+/versionCode ${CODE}/; s/versionName \"[^\"]+\"/versionName \"${NAME}\"/" android/app/build.gradle

echo "Đã áp icon, splash, màu, phiên bản ${NAME} (${CODE})"
