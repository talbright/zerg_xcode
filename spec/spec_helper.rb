
def with_spec_bin
  old_path = ENV['PATH']
  ENV['PATH'] = "./spec/bin:#{ENV['PATH']}"
  yield
  ENV['PATH'] = old_path
end

