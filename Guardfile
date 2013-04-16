# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
end

guard :rspec, :cli => '--drb --format progress --color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/.+\.rb$}) do |m| "spec/#{m[1]}_spec.rb" end
end
