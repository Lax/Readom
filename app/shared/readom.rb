class Readom
  HOST = 'https://readom-api.herokuapp.com'

  def self.fetch_item(item_id, &block)
    itemEntry = 'item/%s.json' % item_id

    self.session.get(itemEntry) do |result|
      if result.success?
        item = result.object

        item_title = item['title']
        item_url = item['url']

        block.call(item)
      end
    end
  end

  def self.fetch_items(list=:newstories, limit=10, &block)
    listEntry = '%s.json?limit=%d' % [list, limit]

    self.session.get(listEntry) do |result|
      if result.success?
        if block
          result.object.shuffle.each do |item|
            if item['title'] and item['url'].nil?
              url = 'https://news.ycombinator.com/item?id=%d' % item['id']
              block.call(item['id'], item['title'], url, item['by'], item['score'], item['time'])
            else
              block.call(item['id'], item['title'], item['url'], item['by'], item['score'], item['time']) unless item['title'].nil?
            end
          end
        end
      end
    end
  end

private
  def self.session
    @session ||= AFMotion::SessionClient.build("#{HOST}/news/v0/") do
      session_configuration :default

      header "Accept", "application/json"

      response_serializer :json
    end
  end
end
