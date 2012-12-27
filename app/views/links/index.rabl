collection :@links
attributes :slug, :original_url, :created_at
node(:short_url) {|link| short_link_url(link)}
