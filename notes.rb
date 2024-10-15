job = HPCKit::Slurm::Job.new(backend, script: "aaaaaa", param1: value1, param2: value2)
job.new? #=> true

HPCKit::Slurm::Job.create(backend, script: "aaaa")
#=> Job
#=> ArrayJob

# submitting a job
job.submit
job.submit!

# existing job
job = HPCKit::Slurm::Job.new(backend, id: "123_1")
job.status #=> triggers update
job.update

Job.where(backend, id: [1,2,3])
Job.find(backend, id: 123)

# paths
job.stdout_path
job.stderr_path

# std out/err payload
job.stdout
job.stderr

job.abort!
job.abort

