class Readom
  def self.fetch_item(item_id, &block)
    itemEntry = 'https://readom-api.herokuapp.com/news/v0/%s.json' % item_id

    AFMotion::JSON.get(itemEntry) do |result|
      if result.success?
        item = result.object

        item_title = item['title']
        item_url = item['url']

        block.call(item['id'], item['title'], item['url'])
      end
    end
  end

  def self.fetch_item_sample(list=:newstories, &block)
    listEntry = 'https://readom-api.herokuapp.com/news/v0/%s.sample' % list

    AFMotion::JSON.get(listEntry) do |result|
      if result.success?
        loop_count = 0
        item_id = result.object.sample

        fetch_item(item_id) do |item|
          block.call(item['id'], item['title'], item['url'])
        end
      end
    end
  end

  def self.fetch_items(list=:newstories, &block)
    listEntry = 'https://readom-api.herokuapp.com/news/v0/%s.json' % list

    AFMotion::JSON.get(listEntry) do |result|
      if result.success?
        result.object.each do |item_id|
          fetch_item(item_id) do |item|
            block.call(item['id'], item['title'], item['url']) unless item['url'].nil?
          end
        end
      end
    end
  end
end