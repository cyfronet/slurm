# HPCKit

Manage HPC jobs for the local computer without struggles.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add hpckit

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install hpckit

## Usage

Current version only adds `slurmrestd` via `local` (default right now) or `netssh`
backends.

To run a command on the `ares` supercomputer run following code e.g. in the
`irb` console:

```ruby
require "hpckit"
require "json"

backend = HPCKit::Slurm::Backends::Netssh.new("ares.cyfronet.pl", "plgusername")
client = HPCKit::Slurm::Restd.new(backend)

job_def = {
  job: {
    name: "test",
    nodes: 1,
    ntasks: 1,
    account: "plgprimage4-cpu",
    partition: "plgrid-now",
    environment: { "ENV_VARIABLE" => "value" }
  },
  script: "#!/bin/bash\nid\nuname -a\ndate\n"
}

res = client.post("/slurm/v0.0.37/job/submit", JSON.generate(job_def), "Content-Type": "application/json")
if res.code_type == Net::HTTPOK
  job_details = JSON.parse(res.body)
  puts client.get("/slurmdb/v0.0.37/job/#{job_details["job_id"]}").body
else
  puts "Error while submitting the job: #{res.body}"
end

# by using one ssh connection
client.start do |conn|
  res = conn.post("/slurm/v0.0.37/job/submit", JSON.generate(job_def), "Content-Type": "application/json")
  if res.code_type == Net::HTTPOK
    job_details = JSON.parse(res.body)
    puts conn.get("/slurmdb/v0.0.37/job/#{job_details["job_id"]}").body
  else
    puts "Error while submitting the job: #{res.body}"
  end
end
```
Note: this script assumes, that you are able to login to ares without password.
If this is not a case you can pass `password: yourpassword` option while
initializing the backend.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/slurm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/slurm/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SSHKit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/slurm/blob/main/CODE_OF_CONDUCT.md).
