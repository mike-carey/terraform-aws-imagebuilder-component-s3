name: ${name}-document
%{ if description != null ~}
description: ${description}
%{ endif ~}
schemaVersion: 1.0
phases:
  - name: build
    steps:
    %{~ if length(directories) > 0 && create_directories ~}
      - name: create-directories
        action: ExecuteBash
        inputs:
          commands:
          %{~ for dir in directories ~}
          - mkdir -p "${dir}"
          %{~ endfor ~}
    %{~ endif ~}
    %{~ if length(download_buckets) > 0 ~}
      - name: arbitrary-s3-download
        action: S3Download
        maxAttempts: ${max_attempts}
        inputs:
        %{~ for bucket in download_buckets ~}
          - source: ${bucket.source}
            destination: ${bucket.destination}
        %{~ endfor ~}
      %{~ endif ~}
      %{~ if length(upload_buckets) > 0 ~}
      - name: arbitrary-s3-download
        action: S3Upload
        maxAttempts: ${max_attempts}
        inputs:
        %{~ for bucket in upload_buckets ~}
          - source: ${bucket.source}
            destination: ${bucket.destination}
        %{~ endfor ~}
      %{~ endif ~}
