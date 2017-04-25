module Helpers
  def with_command(name, **opts)
    cmd = command([name, opts.map { |(k,v)| "-#{k} #{v}" }.join(' ')].compact.join(' '))
    status, out, err = system_exec(cmd)

    if status != 0
      puts "ERROR: #{err}"
    end

    expect(status).to be(0)
    expect(err).to be_empty

    yield(out)
  end

  def command(cmd)
    "#{SPEC_ROOT}/dummy/exe/run #{cmd}"
  end

  # Adapted from Bundler source code
  def system_exec(cmd)
    Open3.popen3(ENV, cmd) do |stdin, stdout, stderr, wait_thr|
      yield stdin, stdout, wait_thr if block_given?

      stdin.close

      exitstatus = wait_thr && wait_thr.value.exitstatus
      out = Thread.new { stdout.read }.value.strip
      err = Thread.new { stderr.read }.value.strip

      [exitstatus, out, err]
    end
  end
end
