local ShopPanel = class("ShopPanelCreate", function(size, color)
	return SoraDCreateColorLayer(size, color)
end)
function ShopPanel:ctor()
	self:initUI()
	self:addTouch()
end
function ShopPanel:addTouch()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		print("touch shopLayer")
	end)
end
function ShopPanel:initUI()
	self:createListView1()
	self:createListView2()
end
function ShopPanel:createListView1()
	_ENV = nil
	;(nil).viewRect = cc.rect(20, 20, 200, 280)
	;(nil).bgColor = cc.c4b(255, 0, 0, 100)
	;(nil).async = true
	;(nil).direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
	self.listView = cc.ui.UIListView.new(nil)
	self.listView:setDelegate(handler(self, self.sourceDelegate))
	self.listView:reload()
end
function ShopPanel:sourceDelegate(listView, tag, idx)
	if cc.ui.UIListView.COUNT_TAG == tag then
		return 20
	else
		if cc.ui.UIListView.CELL_TAG == tag then
			local item, content
			item = self.listView:dequeueItem()
			if not item then
				item = self.listView:newItem()
				_ENV = self.listView
				self.listView.text = "item" .. idx
				self.listView.size = 15
				self.listView.align = cc.ui.TEXT_ALIGN_CENTER
				self.listView.color = display.COLOR_WHITE
				content = cc.ui.UILabel.new(self.listView)
				item:addContent(content)
			else
				content = item:getContent()
			end
			content:setString("item:" .. idx)
			item:setItemSize(200, 50)
			return item
		else
		end
	end
end
function ShopPanel:touchListener1(event)
	local listView = event.listView
	if "clicked" == event.name then
		print("async list view clicked idx:" .. event.itemPos)
	elseif "moved" == event.name then
		self.bListViewMove = true
	elseif "ended" == event.name then
		self.bListViewMove = false
	else
		print("event name:" .. event.name)
	end
end
function ShopPanel:createListView2()
	_ENV = nil
	;(nil).bgColor = cc.c4b(200, 200, 200, 120)
	;(nil).bg = "sunset.png"
	;(nil).bgScale9 = true
	;(nil).viewRect = cc.rect(250, 20, 120, 280)
	;(nil).direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
	;(nil).scrollbarImgV = "bar.png"
	self.lv = cc.ui.UIListView.new(nil)
	for i = 1, 20 do
		do
			local item = self.lv:newItem()
			local content
			if 1 == i then
				_ENV = nil
				;(nil).text = "item" .. i
				;(nil).size = 20
				;(nil).align = cc.ui.TEXT_ALIGN_CENTER
				;(nil).color = display.COLOR_BLACK
				content = cc.ui.UILabel.new(nil)
			elseif 2 == i then
				_ENV = display.COLOR_BLACK
				display.COLOR_BLACK.scale9 = true
				_ENV = 40
				;(40).text = "点击大小改变" .. i
				;(40).size = 16
				;(40).color = display.COLOR_BLUE
				content = cc.ui.UIPushButton.new("GreenButton.png", display.COLOR_BLACK):setButtonSize(120, 40):setButtonLabel(cc.ui.UILabel.new(40)):onButtonPressed(function(event)
					event.target:getButtonLabel():setColor(display.COLOR_RED)
				end):onButtonRelease(function(event)
					event.target:getButtonLabel():setColor(display.COLOR_BLUE)
				end):onButtonClicked(function(event)
					if self.bListViewMove then
						print("TestUIListViewScene is scroll, not click")
						return
					end
					print("TestUIListViewScene buttonclicked")
					local _, h = item:getItemSize()
					if 40 == h then
						item:setItemSize(120, 80)
					else
						item:setItemSize(120, 40)
					end
				end)
				content:setTouchSwallowEnabled(false)
			elseif 3 == i then
				_ENV = content
				content.text = "点击删除它" .. i
				content.size = 20
				content.align = cc.ui.TEXT_ALIGN_CENTER
				content.color = display.COLOR_BLACK
				content = cc.ui.UILabel.new(content)
			elseif 4 == i then
				_ENV = content
				content.text = "有背景图" .. i
				content.size = 20
				content.align = cc.ui.TEXT_ALIGN_CENTER
				content.color = display.COLOR_BLACK
				content = cc.ui.UILabel.new(content)
				item:setBg("YellowBlock.png")
			else
				_ENV = item
				item.text = "item" .. i
				item.size = 20
				item.align = cc.ui.TEXT_ALIGN_CENTER
				item.color = display.COLOR_BLACK
				content = cc.ui.UILabel.new(item)
			end
			item:addContent(content)
			item:setItemSize(120, 40)
			self.lv:addItem(item)
		end
	end
	self.lv:reload()
end
function ShopPanel:touchListener2(event)
	local listView = event.listView
	if "clicked" == event.name then
		if 3 == event.itemPos then
			listView:removeItem(event.item, true)
		else
			print("list view clicked idx:" .. event.itemPos)
		end
	elseif "moved" == event.name then
		self.bListViewMove = true
	else
		if "ended" == event.name then
			self.bListViewMove = false
		else
		end
	end
end
return ShopPanel
