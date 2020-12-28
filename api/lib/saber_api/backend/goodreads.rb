require "goodreads"
require "active_support/core_ext/object/try"

class SaberAPI
  module Backend
    class Goodreads < Base
      LANGUAGE_MAP = {
        "eng" => "English",
        "deu" => "German",
        "fra" => "French",
        "spa" => "Spanish",
        "ita" => "Italian",
        "lat" => "Latin",
        "jpn" => "Japanese",
        "dan" => "Danish",
        "swe" => "Swedish",
        "nor" => "Norwegian",
        "nld" => "Dutch",
        "rus" => "Russian",
        "pol" => "Polish",
        "por" => "portuguese",
        "ell" => "greek",
        "gle" => "irish",
        "gla" => "Gaelic",
        "kor" => "Korean",
        "zho" => "Chinese",
        "ara" => "Arabic"
      }

      FIELD_MAP = {
        "id" => "id",
        "title" => "title",
        "authors" => proc {|v| [ v["authors"]["author"][0]["name"] ]},
        "isbn" => "isbn13",
        "isbn10" => "isbn",
        "publisher" => "publisher",
        "pages" => "num_pages",
        "publication_date" => proc {|v| 
          date = [ v["publication_year"], v["publication_month"], v["publication_day"] ].compact
          [ date[0], date[1..-1].try(:map){|v| format("%02d", v)} ].compact.join("-")
        },
        "language" => proc{|v| LANGUAGE_MAP[v["language_code"]] },
        "tags" => proc{|v| convert_tags(*v["popular_shelves"]["shelf"].map{|v| v["name"]}) },
        "image" => "image_url",
        "description" => "description",
      }

      # select from 10000+ books
      TAGS = %w[
        fiction
        non-fiction
        fantasy
        romance
        young-adult
        mystery
        classics
        history
        historical-fiction
        contemporary
        paranormal
        science-fiction
        manga
        adult
        childrens
        horror
        adventure
        novels
        biography
        literature
        science
        chick-lit
        humor
        thriller
        comics
        reference
        urban-fantasy
        poetry
        philosophy
        graphic-novels
        crime
        picture-books
        paranormal-romance
        vampires
        book-club
        adult-fiction
        historical-romance
        suspense
        short-stories
        contemporary-romance
        religion
        drama
        magic
        school
        erotica
        supernatural
        politics
        american
        art
        memoir
        teen
        psychology
        christian
        realistic-fiction
        family
        travel
        juvenile
        mystery-thriller
        20th-century
        dystopia
        action
        animals
        love
        funny
        war
        literary-fiction
        modern
        comedy
        high-school
        music
        business
        mythology
        relationships
        theology
        college
        cookbooks
        spirituality
        christian-fiction
        speculative-fiction
        self-help
        education
        coming-of-age
        culture
        military
        detective
        science-fiction-fantasy
        middle-grade
        read-for-school
        sociology
        plays
        food
        death
        romantic-suspense
        inspirational
        essays
        bdsm
        dark
        christianity
        19th-century
        autobiography
        erotic-romance
        writing
        steampunk
        romantic
        language
        roman
        epic
        health
        academic
        werewolves
        m-m-romance
        economics
        classic-literature
        biography-memoir
        angels
        feminism
        film
        fairy-tales
        zombies
        sports
        ghosts
        nature
        gothic
        cooking
        witches
        chapter-books
        social
        western
        textbooks
        glbt
        demons
        epic-fantasy
        criticism
        research
        movies
        british-literature
        anthologies
        france
        american-history
        survival
        harlequin
        english-literature
        time-travel
        gay
        medieval
        murder-mystery
        high-fantasy
        society
        united-states
        parenting
        photography
        post-apocalyptic
        modern-classics
        cozy-mystery
        cultural
        shapeshifters
        dragons
        regency
        teaching
        star-wars
        magical-realism
        international
        christmas
        africa
        anthropology
        japan
        grad-school
        faith
        class
        canon
        theory
        technology
        queer
        asia
        dark-fantasy
        espionage
        true-crime
        americana
        menage
        tragedy
        collections
        leadership
        medical
        theatre
        noir
        young-readers
        alternate-history
        historical-mystery
        design
        marriage
        books-about-books
        abuse
        gender
        folklore
        military-history
        young-adult-fantasy
        pop-culture
        pulp
        social-issues
        sexuality
        african-american
        fantasy-romance
        world-war-ii
        occult
        germany
        russia
        law
        architecture
        space
        storytime
        italy
        china
        womens-fiction
        new-york
        apocalyptic
        paranormal-urban-fantasy
        literary-criticism
        how-to
        european-literature
        ireland
        programming
        slice-of-life
        american-fiction
        holiday
        crafts
        fairies
        graphic-novels-comics
        aliens
        academia
        dogs
        environment
        social-science
        regency-romance
        mathematics
        adolescence
        india
        islam
        southern
        gardening
        political-science
        french-literature
        jewish
        european-history
        biology
        space-opera
        buddhism
        mental-illness
        australia
        banned-books
        medicine
      ]

      TAG_MAP = {
        "non fiction" => "nonfiction"
      }

      def initialize
        @client = ::Goodreads.new(api_key: ENV["GOODREADS_KEY"])
      end

      def book(isbn)
        begin
          data = client.book_by_isbn(isbn)
        rescue ::Goodreads::NotFound
          {}
        else
          # fix
          if Hash === data["authors"]["author"]
            data["authors"]["author"] = [data["authors"]["author"]]
          end

          SaberAPI.convert_fields(self, FIELD_MAP, data)
        end
      end

    protected

      # @return [Array] tags
      def convert_tags(*tags)
        tags.find_all{|v| 
          TAGS.include?(v)
        }.sort_by {|v| 
          %w[fiction non-fiction].include?(v) ? -1 : tags.index(v)
        }.map{|v|
          v = TAG_MAP[v] || v
          v.gsub(/-/, " ")
        }
      end
    end
  end
end

# vim: fdn=4
