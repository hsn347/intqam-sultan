local cityEffectInfoRead = include("cityEffectInfoRead")
local CitybuffDesView = class("citybuffDesView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("citybuffDesView")
	end
	return target
end)
function CitybuffDesView:ctor()
	self.timerNumber = 0
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.singCopy = SoraDGetChildByName(self, "Image_single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
end
function CitybuffDesView:initKingBattleData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	self.buffList, _ENV, self.timerNumber = conquestWarCtrl:getConquestWarWinBuffLefttime() or 0, conquestWarCtrl:getConquestWarWinBuffLefttime() or 0, conquestWarCtrl:getConquestWarWinBuffLefttime() or 0
	if not cityEffectInfoRead.getKingBattleInfoInfo() then
		_ENV = cityEffectInfoRead.getKingBattleInfoInfo()
	end
	for k, v in pairs((cityEffectInfoRead.getKingBattleInfoInfo())) do
		table.insert(self.buffList, v)
	end
	self:initKingBattleView()
end
function CitybuffDesView:initKingBattleView(...)
	self.ccs_bg:setTitleName(i18n("common_text_3038"))
	_ENV = i18n("common_text_3038")
	i18n("common_text_3038").num = #self.buffList
	SoraDGetChildByName(self, "Text_buffCount"):setString(i18n("common_text_3039", i18n("common_text_3038")))
	local editSingle = function(ocx, info)
		local itemDesRead = include("itemDesRead")
		local img = info.icon
		ocx:getChildByName("Image_head"):loadTexture(img, ccui.TextureResType.plistType)
		ocx:getChildByName("Image_itemBg"):loadTexture(itemDesRead.getBgByLv(info.iconBg), ccui.TextureResType.plistType)
		ocx:getChildByName("Text_name"):setString(i18n(info.name))
		ocx:getChildByName("Text_des"):setString(i18n(info.des))
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #self.buffList * 100)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.buffList) do
		local single = self.singCopy:clone()
		editSingle(single, v)
		single:setPosition(sSize.width / 2, sH - (i - 1) * 100)
		single:addTo(self.scroll)
	end
	self.txtTime:setTimeLast(function(str, tick)
		self.loadingBar:setPercent(tick / CONQUESTWAR_WIN_BUFF_LASTTIME * 100)
		self = tick / CONQUESTWAR_WIN_BUFF_LASTTIME * 100
		;(tick / CONQUESTWAR_WIN_BUFF_LASTTIME * 100).time = str
		local reText = i18n("common_text_421", tick / CONQUESTWAR_WIN_BUFF_LASTTIME * 100)
		return reText
	end)
	self.txtTime:setTimeEndListener(function(...)
		self:removeFromParent()
	end)
	self.txtTime:beginTime(self.timerNumber)
end
return CitybuffDesView
