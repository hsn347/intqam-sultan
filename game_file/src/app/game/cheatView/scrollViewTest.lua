local DNodeItem = class("DNodeItem", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function DNodeItem:ctor()
	local layout = ccui.Layout:create()
	layout:addTo(self)
	layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	layout:setBackGroundColor(cc.c3b(math.random(255), math.random(255), math.random(255)))
	self.layout = layout
	local labelName = ccui.Text:create()
	labelName:setFontSize(18)
	labelName:setColor(cc.c3b(255, 0, 0))
	labelName:setString(i18n("common_text_2731"))
	labelName:addTo(self)
	_ENV, _ENV, self.labelName = labelName, labelName.addTo, labelName
	labelName.color = cc.c3b(120, 250, 120)
	_ENV, labelName.addTo[1], labelName.nodeHeight = labelName, labelName, 100
	labelName.color = cc.c3b(250, 250, 120)
	_ENV, labelName.addTo[2], labelName.nodeHeight = labelName, labelName, 150
	labelName.color = cc.c3b(120, 250, 220)
	self.nodeTypeCfg, labelName.addTo[3], labelName.nodeHeight = labelName.addTo, labelName, 200
	self:updateWithNodeType(1)
end
function DNodeItem:init(data)
	self.data = data
	self.index = data.index
	self.nodeType = data.nodeType
	self.labelName:setString(string.format("%d, nodeType =%d", self.index, self.nodeType))
	self:updateWithNodeType(self.nodeType)
end
function DNodeItem:updateWithNodeType(nodeType)
	self.nodeWidth = 580
	local cfg = self.nodeTypeCfg[nodeType]
	self.nodeHeight = cfg.nodeHeight
	self.layout:setContentSize(cc.size(self.nodeWidth, self.nodeHeight))
	self.labelName:setPositionX(self.nodeWidth / 2)
	self.labelName:setPositionY(self.nodeHeight / 2)
end
function DNodeItem:getNodeWidth()
	return self.nodeWidth
end
function DNodeItem:getNodeHeight()
	return self.nodeHeight
end
local scrollViewTest = class("scrollViewTest", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function scrollViewTest:ctor()
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Size_Tile_Image_bg:setFillType(0)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.Top_Size_Tile_Image_bg:loadTexture("frame_chat_12.png", ccui.TextureResType.plistType)
	self:init()
end
function scrollViewTest:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function scrollViewTest:init(data)
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setAnchorPoint(0, 0)
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(1)
	self.scrollView:setPosition(cc.p(30, 30))
	self.scrollView:addTo(self, 1)
	self.scrollView:setContentSize(cc.size(580, 800))
	self.scrollView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	self.scrollView:setBackGroundColor(cc.c3b(128, 128, 128))
	self.listData, _ENV, self.itemsData, _ENV = self.scrollView.setBackGroundColor, self.scrollView.setBackGroundColor, self.scrollView.setBackGroundColor, self.scrollView.setBackGroundColor
	self.wGet = false
	self.sIndex = 1
	self.scroll = include("commonScrollView").new(self.scrollView)
	_ENV = cc.c3b(128, 128, 128)
	cc.c3b(128, 128, 128).listData = self.listData
	cc.c3b(128, 128, 128).nodeSizeType = gScrollViewNodeSizeType.dynamic
	cc.c3b(128, 128, 128).createNodeHandler = handler(self, self.createSingleNode)
	cc.c3b(128, 128, 128).nodeDirection = gScrollViewNodeDirection.top
	cc.c3b(128, 128, 128).dragTipType = gScrollViewDragTipType.bottom
	cc.c3b(128, 128, 128).requestHandler = handler(self, self.requestHandler)
	self.scroll:init(cc.c3b(128, 128, 128))
	self:req4Data(self.sIndex)
	self.scroll:navigateToIndex(4)
end
function scrollViewTest:requestHandler()
	if self.wGet then
		self:req4Data(self.sIndex)
	end
end
function scrollViewTest:req4Data(startIndex)
	SoraDCloseLoading(self)
	local _ENV, ret = SoraDCloseLoading, SoraDCloseLoading
	local idx = startIndex
	local wget
	if 30 < startIndex then
		wget = false
	else
		wget = true
	end
	print("req4Data startIndex = ", startIndex, "wget = ", wget)
	if wget then
		local count = 10
		if startIndex <= 30 then
			for i = 1, count do
				_ENV = nil
				;(nil).nodeType = math.random(3)
				;(nil).name = "name_" .. startIndex + i - 1
				table.insert(ret, nil)
			end
		end
		idx = idx + count
	end
	_ENV = 1
	;(1).idx = idx
	;(1).wget = wget
	;(1).dataList = ret
	self:rspData(nil, 1)
end
function scrollViewTest:rspData(target, data)
	dump(data, "scrollViewTest:rspData(target, data)")
	self.sIndex = data.idx
	self.wGet = data.wget
	if next(data.dataList) ~= nil then
		local cpyTbl = clone(data.dataList)
		for i, v in ipairs(cpyTbl) do
			table.insert(self.itemsData, v)
		end
		self.listData, _ENV = ipairs(cpyTbl)
		for i, v in ipairs(self.itemsData) do
			_ENV = v
			v.index = i
			v.nodeType = v.nodeType
			v.data = v
			table.insert(self.listData, v)
		end
		self.scroll:refreshList(self.listData)
	end
	print(" self.wGet  = ", self.wGet)
	if not self.wGet then
		self.scroll:setHasMore(false)
	end
end
function scrollViewTest:createSingleNode()
	return DNodeItem.new()
end
return scrollViewTest
