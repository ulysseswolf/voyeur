require 'spec_helper'

describe Voyeur::Ogv do
  context "New Video" do
    let(:converter) { Voyeur::Converter.create(format: :ogv) }
    let(:media) { Voyeur::Media.new(filename: 'test_media.ogv') }

    it "uses the correct factory" do
      converter.class.to_s.should == "Voyeur::Ogv"
    end

    context "#convert_options" do
      it "default convert string" do
        converter.convert_options.should == "-b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30"
      end

      it "raises an exception if no media is passed" do
        media = nil
        -> { converter.convert(media: media) }.should raise_error Voyeur::Exceptions::NoMediaPresent
      end

      it "should return a media" do
        converter.convert(media: media)
        converter.input_media.should == media
      end
    end
  end

  context "An invalid Video" do
    let(:converter) { Voyeur::Converter.create(format: :ogv) }
    let(:media) { Voyeur::Media.new(filename: 'test_media.mpeg') }

    context "File does not exist" do
      it "returns conversion status indicating failure" do
        result = converter.convert(media: media)
        result[:status].should == 1
        result[:media].should == converter.output_media
        result[:error_message].should match(/test_media.mpeg: No such file or directory/)
        result[:stderr].nil?.should == false
      end
    end
  end
end
