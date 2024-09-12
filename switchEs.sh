#!/bin/bash

# Daftar untuk menyimpan window ID aktif
declare -a windows

# Fungsi untuk mendapatkan daftar semua jendela aktif
update_windows() {
    windows=($(xdotool search --onlyvisible --class "" | xargs -n 1 xdotool getwindowname | awk '{print $1}'))
}

# Fungsi untuk berpindah ke jendela aktif berikutnya
switch_to_next_window() {
    # Update daftar jendela
    update_windows

    if [ ${#windows[@]} -eq 0 ]; then
        echo "Tidak ada jendela aktif ditemukan."
        return
    fi

    # Dapatkan jendela yang aktif saat ini
    current_window=$(xdotool getactivewindow)
    
    # Temukan index jendela saat ini dalam daftar
    for i in "${!windows[@]}"; do
        if [ "${windows[$i]}" == "$current_window" ]; then
            # Pindah ke jendela berikutnya
            next_index=$(( (i + 1) % ${#windows[@]} ))
            next_window=${windows[$next_index]}
            xdotool windowactivate "$next_window"
            return
        fi
    done

    # Jika tidak ada jendela aktif, aktifkan jendela pertama
    xdotool windowactivate "${windows[0]}"
}

# Deteksi input tombol Tab
while true; do
    # Jika tombol Tab ditekan, lakukan switching ke jendela berikutnya
    read -rsn1 input
    if [ "$input" = $'\t' ]; then
        switch_to_next_window

    fi
echo "Current window: $current_window"
echo "Next window: $next_window"

done
