# frozen_string_literal: true

module Helpers
  def with_command(command, env: {})
    status, out = system_exec(env, "#{SPEC_ROOT}/fixtures/dummy_app/bin/run #{command}")

    if status != 0
      puts out
    end

    expect(status).to eq 0

    yield(out)
  end

  # Adapted from Bundler source code
  def system_exec(env, cmd)
    Open3.popen2e(env, cmd) do |stdin, stdout_and_err, wait_thr|
      yield stdin, stdout, wait_thr if block_given?

      stdin.close

      exitstatus = wait_thr && wait_thr.value.exitstatus

      out = stdout_and_err.read

      [exitstatus, out]
    end
  end
end
