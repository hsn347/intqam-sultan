local pageSize = cc.size(620, 240)
local chatEmotionSinglePage = class("chatEmotionSinglePage", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("chatEmotionSinglePage"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatEmotionSinglePage:ctor()
	self.contentLayout = SoraDGetChildByName(self, "ContentPanel")
	if self.contentLayout then
		self.contentLayout:setSwallowTouches(false)
	end
	self:setContentSize(pageSize)
	self.isDataInited = false
end
function chatEmotionSinglePage:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
end
function chatEmotionSinglePage:initWithData(param)
	local row, col, data, chatDelegate
	row = param.row
	col = param.col
	data = param.data
	chatDelegate = param.chatDelegate
	if self.isDataInited == true then
		return
	end
	self.isDataInited = true
	self.row = row
	self.col = col
	self.chatDelegate = chatDelegate
	self.contentLayout:removeAllChildren()
	local contentWidth = self.contentLayout:getContentSize().width
	local contentHeight = self.contentLayout:getContentSize().height
	local itemWidth = contentWidth / col
	local itemHeight = contentHeight / row
	local itemNumber = #data
	self.contentLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	for i = 1, row do
		local hLayout = ccui.Layout:create()
		hLayout:setLayoutType(ccui.LayoutType.HORIZONTAL)
		hLayout:setContentSize(cc.size(contentWidth, itemHeight))
		self.contentLayout:addChild(hLayout)
		hLayout:setSwallowTouches(false)
		for j = 1, col do
			local index = (i - 1) * col + j
			if itemNumber >= index then
				local chatEmotionSingleItem = include("chatEmotionSingleItem")
				local chatEmotionSingleItemNode = chatEmotionSingleItem.new()
				chatEmotionSingleItemNode:setContentSize(cc.size(itemWidth, itemHeight))
				_ENV = cc.size(itemWidth, itemHeight)
				cc.size(itemWidth, itemHeight).data = data[index]
				cc.size(itemWidth, itemHeight).chatDelegate = self.chatDelegate
				chatEmotionSingleItemNode:initWithData(cc.size(itemWidth, itemHeight))
				chatEmotionSingleItemNode:setSwallowTouches(false)
				hLayout:addChild(chatEmotionSingleItemNode)
				local lp1 = ccui.LayoutParameter:create()
				chatEmotionSingleItemNode:setLayoutParameter(lp1)
				local posArabX = (col - index) % 5 * chatEmotionSingleItemNode:getContentSize().width
				local posNormalX = (index - 1) % 5 * chatEmotionSingleItemNode:getContentSize().width
				local posx = SoraDFIsRA() and posArabX or posNormalX
				local posy = itemHeight / 2
				chatEmotionSingleItemNode:setAnchorPoint(cc.p(0, 0.5))
				chatEmotionSingleItemNode:setPosition(cc.p(posx, posy + 15))
				print("posy = ", posy)
			else
				break
			end
		end
	end
end
function chatEmotionSinglePage:cleanData()
	print("被清除掉了")
	self.isDataInited = false
	self.contentLayout:removeAllChildren()
end
return chatEmotionSinglePage
