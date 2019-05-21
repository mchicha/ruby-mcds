WickedPdf.config = {
  exe_path: '/usr/local/bin/wkhtmltopdf',
  zoom: 0.55,
    orientation: 'Landscape',
    viewport_size: '6900x3800',
    encoding: "UTF-8",
    print_media_type: false,
    margin: {
      top:    0.25,
      bottom: 0.25,
      left:   0.25,
      right:  0.25
    },
    extra: "--custom-header PDF-TOKEN #{ENV['WKHTML_ACCESS_TOKEN']}  --enable-javascript --window-status ready_to_print",
}
