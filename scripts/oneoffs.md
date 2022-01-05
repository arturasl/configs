# Video

Reconvert mp4.
```bash
ffmpeg -i input.mp4 -vf "subtitles=input.srt" -f matroska -vcodec h264 -acodec aac output.mp4
```

Offset subtitles.
```bash
ffmpeg -itsoffset 2 -i input.srt -c copy output.srt
```

Concatenate
```bash
ffmpeg \
  -f concat \
  -safe 0 \
  -i <(find "$(pwd)" -maxdepth 1 -name '1_*.mp4' | sort | sed -e 's#.*#file '\''\0'\''#') \
  -c copy \
  out.mp4
```

Play with subtitles (use `x` and `z` to adjust delay; `v` to hide)
```bash
mplayer v.mp4 -sub v.srt
```

# Pdf

```bash
pdftops input.pdf /dev/stdout | ps2pdf /dev/stdin output.pdf
```
