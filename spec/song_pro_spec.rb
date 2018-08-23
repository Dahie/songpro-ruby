# frozen_string_literal: true

RSpec.describe SongPro do
  context 'attributes' do
    it 'parses title attributes' do
      song = SongPro.parse('@title=Bad Moon Rising')

      expect(song.title).to eq('Bad Moon Rising')
    end

    it 'parses artists attributes' do
      song = SongPro.parse('@artist=Creedence Clearwater Revival')

      expect(song.artist).to eq('Creedence Clearwater Revival')
    end

    it 'parses multiple attributes' do
      song = SongPro.parse('
@title=Bad Moon Rising
@artist=Creedence Clearwater Revival
')

      expect(song.title).to eq('Bad Moon Rising')
      expect(song.artist).to eq('Creedence Clearwater Revival')
    end
  end

  context 'sections' do
    it 'parses section names' do
      song = SongPro.parse('# Verse 1')

      expect(song.sections.size).to eq 1
      expect(song.sections[0].name).to eq 'Verse 1'
    end

    it 'parses multiple section names' do
      song = SongPro.parse('
# Verse 1
# Chorus
')
      expect(song.sections.size).to eq 2
      expect(song.sections[0].name).to eq 'Verse 1'
      expect(song.sections[1].name).to eq 'Chorus'
    end
  end

  context 'lyrics' do
    it 'parses lyrics' do
      song = SongPro.parse('I see a bad moon a-rising')

      expect(song.sections.size).to eq 1
      expect(song.sections[0].lines.size).to eq 1
      expect(song.sections[0].lines[0].parts.size).to eq 1
      expect(song.sections[0].lines[0].parts[0].lyric).to eq 'I see a bad moon a-rising'
    end
  end

  context 'chords' do
    it 'parses chords' do
      song = SongPro.parse('[D] [A] [G] [D]')
      expect(song.sections.size).to eq 1
      expect(song.sections[0].lines.size).to eq 1
      expect(song.sections[0].lines[0].parts.size).to eq 4
      expect(song.sections[0].lines[0].parts[0].chord).to eq 'D'
      expect(song.sections[0].lines[0].parts[0].lyric).to eq ''
      expect(song.sections[0].lines[0].parts[1].chord).to eq 'A'
      expect(song.sections[0].lines[0].parts[1].lyric).to eq ''
      expect(song.sections[0].lines[0].parts[2].chord).to eq 'G'
      expect(song.sections[0].lines[0].parts[2].lyric).to eq ''
      expect(song.sections[0].lines[0].parts[3].chord).to eq 'D'
      expect(song.sections[0].lines[0].parts[3].lyric).to eq ''
    end
  end

  context 'chords and lyrics' do
    it 'parses chords and lyrics' do
      song = SongPro.parse("[G]Don't go 'round tonight")
      expect(song.sections.size).to eq 1
      expect(song.sections[0].lines.size).to eq 1
      expect(song.sections[0].lines[0].parts.size).to eq 1
      expect(song.sections[0].lines[0].parts[0].chord).to eq 'G'
      expect(song.sections[0].lines[0].parts[0].lyric).to eq "Don't go 'round tonight"
    end

    it 'parses lyrics before chords' do
      song = SongPro.parse("It's [D]bound to take your life")
      expect(song.sections.size).to eq 1
      expect(song.sections[0].lines.size).to eq 1
      expect(song.sections[0].lines[0].parts.size).to eq 2
      expect(song.sections[0].lines[0].parts[0].chord).to eq ''
      expect(song.sections[0].lines[0].parts[0].lyric).to eq "It's"
      expect(song.sections[0].lines[0].parts[1].chord).to eq 'D'
      expect(song.sections[0].lines[0].parts[1].lyric).to eq 'bound to take your life'
    end
  end
end
