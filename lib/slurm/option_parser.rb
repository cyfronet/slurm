# frozen_string_literal: true

require "optparse"

class Slurm::OptionParser < ::OptionParser
  attr_reader :options

  def initialize(args)
    @options = {}
    super do |opts|
      opts.on("-A", "--account=NAME", "Charge resources used by this job to specified account.") { |v| @options[:account] = v }
      opts.on("--acctg-freq=DATATYPE_INTERVAL", "Define the job accounting and profiling sampling intervals.") { |v| @options[:account_gather_frequency] = v }
      # opts.on("-", "--", "Arguments to the script.") { |v| @options[:argv] = v } #array
      opts.on("-a", "--array=INDEXES", "Submit a job array, multiple jobs to be executed with identical parameters. The indexes specification identifies what array index values should be used.") { |v| @options[:array] = v }
      opts.on("--batch=FEATURES", "features required for batch script's node") { |v| @options[:batch_features] = v }
      opts.on("-b", "--begin=TIME", "Submit the batch script to the Slurm controller immediately, like normal, but tell the controller to defer the allocation of the job until the specified time.") { |v| @options[:begin_time] = v } # integer - tutaj będzie trzeba to zmienić
      opts.on("--bb=SPECIFICATION", "Burst buffer specification.") { |v| @options[:burst_buffer] = v }
      opts.on("--cluster-constraint=CONSTRAINTS", "Specifies features that a federated cluster must have to have a sibling job submitted to it.") { |v| @options[:cluster_constraint] = v }
      opts.on("--comment=COMMENT", "An arbitrary comment.") { |v| @options[:comment] = v }
      opts.on("-C", "--constraints=CONSTRAINTS", "node features required by job.") { |v| @options[:constraints] = v }
      opts.on("-S", "--core-spec=NUM", Integer, "Count of specialized threads per node reserved by the job for system operations and not used by the application.") { |v| @options[:core_specification] = v } # integer
      opts.on("--cores-per-socket=CORES", "Restrict node selection to nodes with at least the specified number of cores per socket.") { |v| @options[:cores_per_socket] = v } # integer
      # opts.on("-", "--", "Cpu binding") { |v| @options[:cpu_binding] = v }
      # opts.on("-", "--", "Cpu binding hint") { |v| @options[:cpu_binding_hint] = v }
      # opts.on("-", "--", "Request that job steps initiated by srun commands inside this sbatch script be run at some requested frequency if possible, on the CPUs selected for the step on the compute node(s).") { |v| @options[:cpu_frequency] = v }
      opts.on("--cpus-per-gpu=NCPUS", "Number of CPUs requested per allocated GPU.") { |v| @options[:cpus_per_gpu] = v }
      opts.on("-c", "--cpus-per-task=NCPUS", "Advise the Slurm controller that ensuing job steps will require ncpus number of processors per task.") { |v| @options[:cpus_per_task] = v } # integer
      # opts.on("-", "--", "Instruct Slurm to connect the batch script's standard output directly to the file name.") { |v| @options[:current_working_directory] = v }
      opts.on("--deadline=OPT", "Remove the job if no ending is possible before this deadline (start > (deadline - time[-min])).") { |v| @options[:deadline] = v }
      opts.on("--delay-boot=MINUTES", "Do not reboot nodes in order to satisfied this job's feature specification if the job has been eligible to run for less than this time period.") { |v| @options[:delay_boot] = v } # integer
      opts.on("-d", "--dependency=DEPENDENCY_LIST", "Defer the start of this job until the specified dependencies have been satisfied completed.") { |v| @options[:dependency] = v }
      opts.on("-m", "--distribution", "Specify alternate distribution methods for remote processes.") { |v| @options[:distribution] = v }
      # opts.on("-", "--", "Dictionary of environment entries.") { |v| @options[:environment] = v } # object
      opts.on("--exclusive=USER_OR_MCS", "The job allocation can share nodes just other users with the \"user\" option or with the \"mcs\" option).") { |v| @options[:exclusive] = v } # enum - user, mcs, true, false
      opts.on("--get-user-env=TIMEOUT", "Load new login environment for user on job node.") { |v| @options[:get_user_environment] = v } #boolean
      opts.on("--gres=LIST", "Specifies a comma delimited list of generic consumable resources.") { |v| @options[:gres] = v }
      opts.on("--gres-flags=TYPE", "Specify generic resource task binding options.") { |v| @options[:gres_flags] = v } # enum - disable-binding, enforce-binding
      opts.on("-", "--", "Requested binding of tasks to GPU.") { |v| @options[:gpu_binding] = v }
      opts.on("-", "--", "Requested GPU frequency.") { |v| @options[:gpu_frequency] = v }
      opts.on("-G", "--gpus=TYPE_NUMBER", "GPUs per job.") { |v| @options[:gpus] = v }
      opts.on("--gpus-per-node=TYPE_NUMBER", "GPUs per node.") { |v| @options[:gpus_per_node] = v }
      opts.on("--gpus-per-socket=TYPE_NUMBER", "GPUs per socket.") { |v| @options[:gpus_per_socket] = v }
      opts.on("--gpus-per-task=TYPE_NUMBER", "GPUs per task.") { |v| @options[:gpus_per_task] = v }
      opts.on("-H", "--hold", "Specify the job is to be submitted in a held state (priority of zero).") { |v| @options[:hold] = v } # boolean
      opts.on("--kill-on-invalid-dep=YES_NO", "If a job has an invalid dependency, then Slurm is to terminate it.") { |v| @options[:kill_on_invalid_dependency] = v } # boolean
      opts.on("-L", "--licenses=LICENSES", "Specification of licenses (or other resources available on all nodes of the cluster) which must be allocated to this job.") { |v| @options[:licenses] = v }
      opts.on("--mail-type=TYPE", "Notify user by email when certain event types occur.") { |v| @options[:mail_type] = v }
      opts.on("--mail-user=MAIL", "User to receive email notification of state changes as defined by mail_type.") { |v| @options[:mail_user] = v }
      opts.on("--mcs-label=MCS", "This parameter is a group among the groups of the user.") { |v| @options[:mcs_label] = v }
      opts.on("-", "--mem-bind=BIND", "Bind tasks to memory.") { |v| @options[:memory_binding] = v }
      opts.on("--mem-per-cpu=SIZE", "Minimum real memory per cpu (MB).") { |v| @options[:memory_per_cpu] = v } #integer
      opts.on("--mem-per-gpu=SIZE", "Minimum memory required per allocated GPU.") { |v| @options[:memory_per_gpu] = v } #integer
      opts.on("--mem=SIZE", "Minimum real memory per node (MB).") { |v| @options[:memory_per_node] = v } #integer
      opts.on("--mincpus=N", "Minimum number of CPUs per node.") { |v| @options[:minimum_cpus_per_node] = v } #integer
      opts.on("-", "--", "If a range of node counts is given, prefer the smaller count.") { |v| @options[:minimum_nodes] = v } #boolean
      opts.on("-J", "--job-name=NAME", "Specify a name for the job allocation.") { |v| @options[:name] = v }
      opts.on("--nice=ADJUSTMENT", "Run the job with an adjusted scheduling priority within Slurm.") { |v| @options[:nice] = v }
      opts.on("-k", "--no-kill=NO_KILL", "Do not automatically terminate a job if one of the nodes it has been allocated fails.") { |v| @options[:no_kill] = v }
      opts.on("-N", "--nodes=MIN_MAX", "Request that a minimum of minnodes nodes and a maximum node count.") { |v| @options[:nodes] = v } # array integerów, min 1, max 2
      opts.on("--open-mode=APPEND_TRUNCATE", "Open the output and error files using append or truncate mode as specified.") { |v| @options[:open_mode] = v } # append (default), truncate
      opts.on("-p", "--partition=PARTITION_NAMES", "Request a specific partition for the resource allocation.") { |v| @options[:partition] = v }
      opts.on("--priority=VALUE", "Request a specific job priority.") { |v| @options[:priority] = v }
      opts.on("-q", "--qos=QOS", "Request a quality of service for the job.") { |v| @options[:qos] = v }
      opts.on("--[no-]reque", "Specifies that the batch job should eligible to being requeue.") { |v| @options[:requeue] = v } #boolean
      opts.on("--reservation=NAME", "Allocate resources for the job from the named reservation.") { |v| @options[:reservation] = v }
      opts.on("--signal=SIG_NUM", "When a job is within sig_time seconds of its end time, send it the signal sig_num.") { |v| @options[:signal] = v } # pattern - (B:|)sig_num(@sig_time|)
      opts.on("--sockets-per-node=SOCKETS", "Restrict node selection to nodes with at least the specified number of sockets.") { |v| @options[:sockets_per_node] = v } #integer
      opts.on("--spread-job", "Spread the job allocation over as many nodes as possible and attempt to evenly distribute tasks across the allocated nodes.") { |v| @options[:spread_job] = v }
      opts.on("-e", "--error=FILENAME_PATTERN", "Instruct Slurm to connect the batch script's standard error directly to the file name.") { |v| @options[:standard_error] = v }
      opts.on("-i", "--input=FILENAME_PATTERN", "Instruct Slurm to connect the batch script's standard input directly to the file name specified.") { |v| @options[:standard_input] = v }
      opts.on("-o", "--output=FILENAME_PATTERN", "Instruct Slurm to connect the batch script's standard output directly to the file name.") { |v| @options[:standard_output] = v }
      opts.on("-n", "--ntasks=NUMBER", Integer, "Advises the Slurm controller that job steps run within the allocation will launch a maximum of number tasks and to provide for sufficient resources.") { |v| @options[:tasks] = v } # integer
      opts.on("--ntasks-per-core=NUMBER", Integer, "Request the maximum ntasks be invoked on each core.") { |v| @options[:tasks_per_core] = v } #integer
      opts.on("--ntasks-per-node=NTASKS", Integer, "Request the maximum ntasks be invoked on each node.") { |v| @options[:tasks_per_node] = v } # integer
      opts.on("--ntasks-per-socket=NTASKS", Integer, "Request the maximum ntasks be invoked on each socket.") { |v| @options[:tasks_per_socket] = v } # integer
      opts.on("--thread-spec=NUM", Integer, "Count of specialized threads per node reserved by the job for system operations and not used by the application.") { |v| @options[:thread_specification] = v } # integer
      opts.on("--threads-per-core=THREADS", Integer, "Restrict node selection to nodes with at least the specified number of threads per core.") { |v| @options[:threads_per_core] = v } # integer
      opts.on("-t", "--time=TIME", "Step time limit.") { |v| @options[:time_limit] = v } # integer
      opts.on("--time-min=TIME", Integer, "Minimum run time in minutes.") { |v| @options[:time_minimum] = v } # integer
      opts.on("--wait-all-nodes", "Do not begin execution until all nodes are ready for use.") { |v| @options[:wait_all_nodes] = (v == "1") } #boolean
      opts.on("--wckey=WCKEY", "Specify wckey to be used with job.") { |v| @options[:wckey] = v }
    end.parse!(args)
  end
end
