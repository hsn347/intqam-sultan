local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local roaringFlameTroops = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWorldMap/roaringFlameTroops", roaringFlameTroops)
function roaringFlameTroops:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_WARDATA", handler(self, self.onMsgUpdateWarData))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_COLLECT", handler(self, self.onMsgUpdateCollect))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.onMsgUpdateMarchingTroops))
end
function roaringFlameTroops:onInit()
	self.queuesData, _ENV = nil, nil
	local mainUI = SoraDCurrentMainUI()
	local mainUITop = mainUI:getMainUITop()
	self.marchingTroops = mainUITop:getNodeLTTarget("troop")
	self.fields.List_troops:setItemRenderer(handler(self, self.onTroopstemRenderer))
	self.fields.Text_noTroops:setString(i18n("flames_dunes_text343"))
	self:initTabList()
	if not SoraDFIsRA() then
		self.fields.bg:fix()
		self.fields.Image_noTroops:fix()
		self.fields.List_troops:setPositionX(2)
	end
end
function roaringFlameTroops:onShow()
	self:onMsgUpdateWarData()
end
function roaringFlameTroops:initTabList(...)
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, nil, 1
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("common_text_370")
	;(nil).tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("common_text_1962")
	local (nil).callback, param = handler(self, self.onClickTab), nil
	self.fields.com_TabW:initView(param)
end
function roaringFlameTroops:onClickTab(tag)
	self.curTag = tag
	if tag == 1 then
		self.marchingTroops:updateWarVisible(true)
		self.fields.List_troops:setVisible(false)
		self.fields.bg:setVisible(false)
		self.fields.Node_noTroops:setVisible(false)
	else
		self.marchingTroops:updateWarVisible(false)
		self.fields.List_troops:setVisible(true)
		self.fields.bg:setVisible(true)
		self.fields.Node_noTroops:setVisible(true)
	end
end
function roaringFlameTroops:onMsgUpdateCollect(...)
	self.fields.com_TabW:setDefaultClick(2)
	self:updateCollectQueue()
	self:updateComTabW()
end
function roaringFlameTroops:updateCollectQueue(...)
	self.queuesData, roaringFlameWarCtrl = nil, nil
	local resMap = roaringFlameWarCtrl:getResMap()
	for k, v in pairs(resMap) do
		roaringFlameWarCtrl = nil
		;(nil).index = #self.queuesData + 1
		;(nil).qType = 1
		;(nil).objId = tonumber(k)
		;(nil).data = v
		table.insert(self.queuesData, nil)
	end
	local caveList = roaringFlameWarCtrl:getCaveList()
	for i, v in ipairs(caveList) do
		roaringFlameWarCtrl = tonumber(k)
		tonumber(k).index = #self.queuesData + 1
		tonumber(k).qType = 2
		tonumber(k).data = v
		table.insert(self.queuesData, (tonumber(k)))
	end
	table.sort(self.queuesData, function(a, b)
		local endTimeA = a.endCollTime or a.endTime
		local endTimeB = b.endCollTime or b.endTime
		if endTimeA ~= endTimeB then
			return endTimeA < endTimeB
		end
		return a.index < b.index
	end)
	local showCount = #self.queuesData
	self.fields.List_troops:setNumItems(showCount)
	self.fields.List_troops:resizeToFit(showCount)
	if showCount <= 0 then
		self.fields.bg:setHeight(0)
		self.fields.Image_noTroops:setVisible(true)
		self.fields.Text_noTroops:setVisible(true)
	else
		self.fields.bg:setHeight(self.fields.List_troops:getHeight() + 40)
		self.fields.Image_noTroops:setVisible(false)
		self.fields.Text_noTroops:setVisible(false)
	end
end
function roaringFlameTroops:onTroopstemRenderer(index, obj)
	obj:initData(self.queuesData[index + 1])
end
function roaringFlameTroops:onMsgUpdateWarData(...)
	self:updateCollectQueue()
	self:updateComTabW()
end
function roaringFlameTroops:onMsgUpdateMarchingTroops(...)
	self.fields.com_TabW:setDefaultClick(1)
	self:runAction(ffa.callFunc(function(...)
		self:updateComTabW()
	end))
end
function roaringFlameTroops:updateComTabW(...)
	local visible1 = #self.queuesData > 0
	local visible2 = self.marchingTroops:getBaseVisible()
	if visible1 or visible2 then
		self.fields.com_TabW:setVisible(true)
	else
		self.fields.com_TabW:setVisible(false)
	end
end
return roaringFlameTroops
