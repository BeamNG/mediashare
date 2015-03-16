//console.log("batch id: " + batchID);
//console.log("admin id: " + adminID);

Dropzone.options.mediafiledrop = {
  acceptedFiles: 'image/png,.png,image/jpeg,.jpg,image/jpeg,.jpeg,video/webm,.webm,video/mp4,.mp4',
  dictDefaultMessage: '{{DROPZONE_MESSAGE}}',
  parallelUploads: 3,
  maxFilesize: {{MAX_UPLOAD_SIZE / 1048576}},
  clickable: true,
  addRemoveLinks: false,
  complete: function(file) {
    if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
      window.location.href = '/' + batchID + '?admin=' + adminID;
    }
  },
  success: function(file, response) {
    //console.log("file uploaded:");
    //console.log(response)
  },
  sending: function(file, xhr, fd) {
    //console.log("sending...");
    fd.append('t', batchID)
    fd.append('a', adminID)
  },
};