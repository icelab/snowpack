# frozen_string_literal: true

module Helpers
  def with_command(command, env: {})
    cmd = "#{SPEC_ROOT}/fixtures/run #{command}"
    status, out = system_exec(env, cmd)

    if status != 0
      puts out
    end

    expect(status).to eq 0
    # expect(err).to be_empty

    yield(out)
  end

  # Adapted from Bundler source code
  def system_exec(env, cmd)
    # Open3.popen3(env, cmd) do |stdin, stdout, stderr, wait_thr|
    Open3.popen2e(env, cmd) do |stdin, stdout_and_err, wait_thr|
      yield stdin, stdout, wait_thr if block_given?

      stdin.close

      exitstatus = wait_thr && wait_thr.value.exitstatus
      # out = Thread.new { stdout.read }.value.strip
      # err = Thread.new { stderr.read }.value.strip

      out = stdout_and_err.read

      [exitstatus, out]
    end
  end
end
