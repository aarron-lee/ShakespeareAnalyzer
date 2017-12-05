require_relative '../shakespeare_analyzer'

RSpec.describe Api, "#initialize" do
  context "with no args" do
    it "defaults to macbeth @ ibiblio.org" do
      api_endpoint = Api.new()
      expect(api_endpoint.play_name).to eq 'macbeth'
      expect(api_endpoint.base_url).to eq 'http://www.ibiblio.org/xml/examples/shakespeare/'
    end
  end
  context "with args" do
    it "uses specified play_name with default base_url" do
      api_endpoint = Api.new('othello')
      expect(api_endpoint.play_name).to eq 'othello'
      expect(api_endpoint.base_url).to eq 'http://www.ibiblio.org/xml/examples/shakespeare/'
    end
    it "uses specified play_name and base_url" do
      api_endpoint = Api.new('othello', 'http://www.ibiblio.org/xml/examples/shakespeare/')
      expect(api_endpoint.play_name).to eq 'othello'
      expect(api_endpoint.base_url).to eq 'http://www.ibiblio.org/xml/examples/shakespeare/'
    end
  end
end

RSpec.describe Api, "#getPlayInfo" do
  context "with stub api info" do
    char_names = ['MALCOLM', 'MACBETH', 'DONALBAIN', 'Third Witch.']
    api_endpoint = Api.new()
    api_endpoint.xml_info = File.open("spec/macbeth.xml") { |f| Nokogiri::XML(f) }
    characters = api_endpoint.getPlayInfo().characters

    line_counts = {'MALCOLM' => 18, 'MACBETH' => 16, 'DONALBAIN' => 15, 'Third Witch.' => 10}

    it "finds all character names" do
      expect(characters.map{ |char| char.name }).to eq char_names
    end

    it "gets the correct line count per character" do
      characters.each do |character|
        expect(character.line_count).to eq line_counts[character.name]
      end
    end
  end
  context "with invalid/incorrect XML" do
    it "raises an error" do
      api_endpoint = Api.new()
      api_endpoint.xml_info = File.open("spec/fake.xml") { |f| Nokogiri::XML(f) }

      expect{api_endpoint.getPlayInfo()}.to raise_error(RuntimeError)
    end
  end
end
