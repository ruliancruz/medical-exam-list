class HostHelper
  class << self
    def insert_host(html, host)
      script = "<script>const host = '#{determine_host host}';</script>"
      html.sub '</head>', "#{script}</head>"
    end

    private

    def determine_host(host)
      if host == 'localhost'
        'http://localhost:3000'
      else
        ENV.fetch 'HOST', 'http://localhost:3000'
      end
    end
  end
end
