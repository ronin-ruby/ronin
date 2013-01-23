require 'spec_helper'

require 'ronin/url'

describe URL do
  let(:scheme) { 'https' }
  let(:host_name) { 'www.example.com' }
  let(:port) { 8080 }
  let(:path) { '/path' }
  let(:query_params) { {'q' => '1'} }
  let(:query_string) { 'q=1' }
  let(:fragment) { 'frag' }

  let(:uri) do
    URI::HTTPS.build(
      scheme:   scheme,
      host:     host_name,
      port:     port,
      path:     path,
      query:    query_string,
      fragment: fragment
    )
  end

  let(:url) do
    described_class.new(
      scheme:    URLScheme.first_or_create(name: scheme),
      host_name: HostName.first_or_create(address: host_name),
      port:      TCPPort.first_or_create(number: port),
      path:      path,
      fragment:  fragment,
      query_params: [
        {
          name: URLQueryParamName.first_or_create(name: query_params.keys[0]),
          value: query_params.values[0]
        }
      ]
    )
  end

  describe "extract" do
    subject { described_class }

    let(:url1) { subject.parse("http://example.com/page.php?x=1&y=2") }
    let(:url2) { subject.parse("ssh://alice@example.com") }
    let(:text) { "foo #{url1}, bar #{url2} baz" }

    it "should extract multiple URLs from text" do
      expect(subject.extract(text)).to be == [url1, url2]
    end

    it "should yield the extracted URLs if a block is given" do
      urls = []

      subject.extract(text) { |url| urls << url }

      expect(urls).to be == [url1, url2]
    end

    it "should ignore non-absolute URIs" do
      expect(subject.extract('foo : bar')).to be_empty
    end
  end

  describe "[]" do
    before { url.save }

    it "should query URLs using URIs" do
      expect(described_class[uri]).to be == url
    end

    it "should query URLs using Strings" do
      expect(described_class[uri.to_s]).to be == url
    end

    it "should still treat Integer arguments as indexes" do
      expect(described_class[0]).to be == url
    end

    after { url.destroy }
  end

  describe "from" do
    subject { described_class.from(uri) }

    it "should parse URL schemes" do
      expect(subject.scheme).not_to be_nil
      expect(subject.scheme.name).to be == scheme
    end

    it "should parse host names" do
      expect(subject.host_name.address).to be == host_name
    end

    it "should parse port numbers" do
      expect(subject.port.number).to be == port
    end

    it "should parse paths" do
      expect(subject.path).to be == path
    end

    it "should parse query strings" do
      expect(subject.query_string).to be == query_string
    end

    it "should parse URL fragments" do
      expect(subject.fragment).to be == fragment
    end

    it "should normalize the paths of HTTP URIs" do
      uri = URI('http://www.example.com')
      url = described_class.from(uri)

      expect(url.path).to be == '/'
    end
  end

  describe "#host" do
    subject do
      described_class.new(:host_name => {:address => host_name})
    end

    it "should return the URI host String" do
      expect(subject.host).to be == host_name
    end
  end

  describe "#to_uri" do
    subject { url.to_uri }

    it "should convert the scheme" do
      expect(subject.scheme).to be == scheme
    end
    
    it "should convert the host name" do
      expect(subject.host).to be == host_name
    end

    it "should convert the port number" do
      expect(subject.port).to be == port
    end

    it "should convert the path" do
      expect(subject.path).to be == path
    end

    it "should convert the query string" do
      expect(subject.query).to be == query_string
    end

    it "should omit the query string if there are no query params" do
      new_url = described_class.parse('https://www.example.com:8080/path')
      new_uri = new_url.to_uri

      expect(new_uri.query).to be_nil
    end

    it "should convert the fragment" do
      expect(subject.fragment).to be == fragment
    end
  end

  describe "#to_s" do
    subject { url.to_s }

    it "should convert the URL back into a String URI" do
      expect(subject).to be == uri.to_s
    end
  end

  describe "#inspect" do
    subject { url.inspect }

    it "should include the full URL" do
      expect(subject).to include(uri.to_s)
    end
  end
end
