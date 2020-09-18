if Rails.env.development? || Rails.env.test?
  require "bundler/audit/cli"

  namespace :bundler do
    desc "Updates the ruby-advisory-db and runs audit"
    task :audit do
      ["update", "check"].each do |command|
        Bundler::Audit::CLI.start [command]
      end
    end

    desc "Updates the version to latest and commits changes"
    task :upgrade, [:gem] => [:environment] do |t, args|
      output = `bundle update #{args[:gem]}`

      regexp = /Installing (?<gem_name>\S+) (?<new_version>\S+) \(was (?<old_version>\S+)\)/
      updated_gems = output.split("\n").select { |gem_str| gem_str.include?("(was") }

      updated_gems = updated_gems.map { |gem_str|
        match = regexp.match(gem_str)
        match.nil? ? nil : [match[:gem_name], match[:old_version], match[:new_version]]
      }.compact

      updated_gem = updated_gems.find { |g| g[0] == args[:gem] }
      raise "Version stayed the same" if updated_gem.nil?

      puts
      puts "✅ \e[32mGem #{updated_gem[0]} successfully updated from #{updated_gem[1]} to #{updated_gem[2]}\e[0m"
      puts
      pretty_updated_gems = updated_gems.map { |gem_meta| "— #{gem_meta[0]}: #{gem_meta[1]} → #{gem_meta[2]}" }
      pretty_updated_gems.each { |gem_str| puts gem_str }
      puts

      commit_title = "Update #{args[:gem]} gem from #{updated_gem[1]} to #{updated_gem[2]}\n"
      commit_msgs = [commit_title].concat(pretty_updated_gems).join("\n")

      `git add Gemfile.lock`
      `git commit -m "#{commit_msgs}"`
      puts
      puts "✅ \e[32mChanges of Gemfile.lock successfully committed\e[0m"
    rescue => e
      puts
      puts "❌ \e[31mCommand `bundle update #{args[:gem]}` failed with error:\e[0m"
      puts e
      `git restore Gemfile.lock`
    end
  end
end
