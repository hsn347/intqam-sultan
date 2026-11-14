local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local summerPrayRead = include("summerPrayRead")
local summerPrayersPreAwardView = class("summerPrayersPreAwardView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("summerPrayersPreAwardView")
end)
function summerPrayersPreAwardView:ctor(properties)
	self.nodecommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	if summerPrayRead.getActivityType() == 1 then
		self.nodecommonPopBox:setTitleName(i18n("pray_text_05"))
	else
		self.nodecommonPopBox:setTitleName(i18n("Icefestival2024_text11"))
	end
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	_ENV = handler(self, self.nodeSingleRefresh)
	handler(self, self.nodeSingleRefresh).scroll = self.scroll
	handler(self, self.nodeSingleRefresh).view = self
	self.scroll:updateScrollView(cc.size(520, 120), summerPrayRead.getAwardConfig(), 1, handler(self, self.nodeSingleRefresh))
	self.scroll:setTouchEnabled(false)
end
function summerPrayersPreAwardView:nodeSingleRefresh(parent, data)
	local nodeBag = SoraDGetChildByName(parent, "Node_Bag")
	local imgBox = SoraDGetChildByName(parent, "Image_Box")
	local textBoxName = SoraDGetChildByName(parent, "Text_BoxName")
	local nodeAward = SoraDGetChildByName(parent, "Node_Award")
	local imageName = string.format("icon_army_level_%s%d.png", SoraDFIsRA() and "" or "Roman_", data.packorder)
	SoraDPrint(imageName)
	SoraDGetChildByName(parent, "Image_Level"):loadTexture(imageName, ccui.TextureResType.plistType)
	imgBox:loadTexture(publicRead.getIcon(data.packreward1[1].id), ccui.TextureResType.plistType)
	textBoxName:setString(i18n(publicRead.getName(data.packreward1[1].id)))
	local ret = backpackltCtrl:getRandomGiftShowItems(data.packreward1[1].id)
	table.sort(ret, function(l, r)
		if publicRead.getQuality(l.id) == publicRead.getQuality(r.id) then
			if l.count == r.count then
				return l.id > r.id
			else
				return l.count > r.count
			end
		else
			return publicRead.getQuality(l.id) > publicRead.getQuality(r.id)
		end
	end)
	nodeAward:removeAllChildren()
	for i, v in ipairs(ret) do
		local single = include("commonItemAward").new()
		single:setScale(0.8)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:setOwnScroll(self.scroll)
		single:setPositionY(0)
		single:addTo(nodeAward)
		single:initData(v.id, v.count)
	end
	SoraDautoSortPos(nodeAward, 5, SoraDFIsRA() and 2 or 0, cc.size(90, 90), not SoraDFIsRA())
end
function summerPrayersPreAwardView:createScrollSingle(parent, data)
	local single = self.nodeSingle:clone()
	return single
end
return summerPrayersPreAwardView
