
#!/bin/bash
set -e

EXAMPLES_DIR="../examples"
BIN_DIR="../examples/"
RESULT_FILE="timings3.csv"

SIZES=(1 2 4 8 16)
N=2000
mkdir -p "$BIN_DIR"

echo "matrix_size,compute,discB_compute,sharedB_compute" > "$RESULT_FILE"

for S in "${SIZES[@]}"; do
    MTX_FILE="$EXAMPLES_DIR/matrix_${N}.mtx"
    BIN_FILE="$BIN_DIR/matrix_${N}.bin"
    META_FILE="$BIN_DIR/matrix_${N}_meta.txt"

    if [[ ! -f "$MTX_FILE" ]]; then
        echo "WARNING: $MTX_FILE does not exist. Skipping."
        continue
    fi

    echo "Converting $MTX_FILE → $BIN_FILE"
    ./mtx2bin "$MTX_FILE" "$BIN_FILE" "$META_FILE"

    echo "Running compute variants for $N×$N..."

    # Time compute
    T1=$( (/usr/bin/time -f "%e" \
        ./compute --a "$BIN_FILE" --a_meta "$META_FILE" \
                  --b "$BIN_FILE" --b_meta "$META_FILE" --nprocs ${S} \
        >/dev/null) 2>&1 )

    # Time discB_compute
    T2=$( (/usr/bin/time -f "%e" \
        ./discB_compute --a "$BIN_FILE" --a_meta "$META_FILE" \
                        --b "$BIN_FILE" --b_meta "$META_FILE" --nprocs ${S} \
        >/dev/null) 2>&1 )

    # Time sharedB_compute
    T3=$( (/usr/bin/time -f "%e" \
        ./sharedB_compute --a "$BIN_FILE" --a_meta "$META_FILE" \
                          --b "$BIN_FILE" --b_meta "$META_FILE" --nprocs ${S} \
        >/dev/null) 2>&1 )

    echo "Times: compute=$T1, discB=$T2, sharedB=$T3"

    # Append to CSV
    echo "${N},${T1},${T2},${T3}" >> "$RESULT_FILE"
done

echo "Done. Results saved to $RESULT_FILE"

