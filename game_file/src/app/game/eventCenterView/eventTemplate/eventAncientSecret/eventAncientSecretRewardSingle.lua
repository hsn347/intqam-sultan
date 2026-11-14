local gametop = gModuleMgr.getObject("gametop")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local ancientTreasureRead = include("ancientTreasureRead")
local eventAncientSecretRewardSingle = class("eventAncientSecretRewardSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventAncientSecretRewardSingle")
	end
	return target
end)
function eventAncientSecretRewardSingle:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_type:setSwallowTouches(false)
	self.Button_type = include("commonBtnInstance").new(self.Button_type)
	self.Button_type:setTouchEnabled(false)
	self.Button_go:setSwallowTouches(false)
	self.Button_go:addTouchEventListener(handler(self, self.onGoClick))
	self.Text_hbNum = SoraDChangeTextToHtml(self.Text_hbNum)
	self.Text_czNum = SoraDChangeTextToHtml(self.Text_czNum)
end
function eventAncientSecretRewardSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	dump(self.data)
	local typePng = "icon_sgjz_chat_01.png"
	local scale = 0.8
	local buildInfo = ancientTreasureRead.getBuildInfo(self.data.buildType)
	local buildSvrInfo = ancientTreasureRead.getSvrBuildInfo(self.data.buildType)
	if self.data.buildStatus == gATBuildingStatus.AT_EXPLORE then
		typePng = "icon_sgjz_chat_01.png"
		self.Button_go:setTitleText(i18n("AncienTreasure_text_62"))
		local torchCount = self.data.torchCount
		local spadeCount = self.data.spadeCount
		if torchCount == buildSvrInfo.torch then
			_ENV = i18n("AncienTreasure_text_62")
			i18n("AncienTreasure_text_62").type = i18n(buildInfo.name)
			self.Text_type:setString(i18n("common_text_3516", i18n("AncienTreasure_text_62")))
		else
			_ENV = i18n("common_text_3516", i18n("AncienTreasure_text_62"))
			i18n("common_text_3516", i18n("AncienTreasure_text_62")).type = i18n("AncienTreasure_text_60")
			self.Text_type:setString(i18n("common_text_3516", i18n("common_text_3516", i18n("AncienTreasure_text_62"))))
		end
		if spadeCount == buildSvrInfo.spade then
			_ENV = i18n("common_text_3516", i18n("common_text_3516", i18n("AncienTreasure_text_62")))
			i18n("common_text_3516", i18n("common_text_3516", i18n("AncienTreasure_text_62"))).num = string.formatnumberthousands(buildInfo.num)
			self.Text_count:setString(i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", i18n("AncienTreasure_text_62")))))
		else
			_ENV = i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", i18n("AncienTreasure_text_62"))))
			i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", i18n("AncienTreasure_text_62")))).num = i18n("AncienTreasure_text_60")
			self.Text_count:setString(i18n("AncienTreasure_text_31", i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", i18n("AncienTreasure_text_62"))))))
		end
		scale = 0.9
		self.Node_myUse:setVisible(true)
		if torchCount >= buildSvrInfo.torch then
			self.Text_hbNum:setString(torchCount .. "/" .. buildSvrInfo.torch)
		else
			_ENV = torchCount
			torchCount.color = "#FF0000"
			local tCount = SoraDWrapHtmlTagByStyle(tostring(torchCount), torchCount)
			self.Text_hbNum:setString(tCount .. "/" .. buildSvrInfo.torch)
		end
		if spadeCount >= buildSvrInfo.spade then
			self.Text_czNum:setString(spadeCount .. "/" .. buildSvrInfo.spade)
		else
			_ENV = spadeCount
			spadeCount.color = "#FF0000"
			local sCount = SoraDWrapHtmlTagByStyle(tostring(spadeCount), spadeCount)
			self.Text_czNum:setString(sCount .. "/" .. buildSvrInfo.spade)
		end
		self.Button_type:setTouchEnabled(false)
	elseif self.data.buildStatus == gATBuildingStatus.AT_MINNING then
		typePng = buildInfo.icon
		self.Button_go:setTitleText(i18n("AncienTreasure_btn_08"))
		_ENV = i18n("AncienTreasure_btn_08")
		i18n("AncienTreasure_btn_08").type = i18n(buildInfo.name)
		self.Text_type:setString(i18n("common_text_3516", i18n("AncienTreasure_btn_08")))
		_ENV = i18n("common_text_3516", i18n("AncienTreasure_btn_08"))
		i18n("common_text_3516", i18n("AncienTreasure_btn_08")).num = string.formatnumberthousands(buildInfo.num)
		self.Text_count:setString(i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("AncienTreasure_btn_08"))))
		scale = 0.8
		self.Node_myUse:setVisible(false)
		self.Button_type:setItemInfo(self.view, buildInfo.item, 1)
		self.Button_type:setTouchEnabled(true)
	end
	SoraDAutoSizeButtonText(self.Button_go)
	self.Sprite_type:setSpriteFrame(typePng)
	self.Sprite_type:setScale(scale)
	_ENV = 1
	;(1).name = self.data.nickName
	self.Text_name:setString(i18n("AncienTreasure_text_59", 1))
	SoraDSetTextWidthHeight(self.Text_name, cc.size(400, 60))
	local svrPos = self:changeToSvrPos(cc.p(self.data.buildX, self.data.buildY))
	self.Text_pos:setString(svrPos.x .. "," .. svrPos.y)
	SoraDDrawTextUnderLine(self.Text_pos, cc.c4b(105, 180, 230, 255))
	self.Text_pos:setTouchEnabled(true)
	self.Text_pos:addTouchEventListener(handler(self, self.onGoClick))
	_ENV = handler(self, self.onGoClick)
	handler(self, self.onGoClick).distance = self.data.distance
	self.Text_distance:setString(i18n("AncienTreasure_text_61", handler(self, self.onGoClick)))
end
function eventAncientSecretRewardSingle:changeToSvrPos(pos)
	return cc.p(pos.x - 1, pos.y - 1)
end
function eventAncientSecretRewardSingle:onGoClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).x = self.data.buildX - 1
		;(nil).y = self.data.buildY - 1
		SoraDGotoWorldMapPoint(nil, true)
		SoraDRemoveAllPanelFromManager()
	end
end
return eventAncientSecretRewardSingle
