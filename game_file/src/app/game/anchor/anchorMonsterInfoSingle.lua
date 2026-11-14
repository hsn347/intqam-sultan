local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local anchorMonsterInfoSingle = class("anchorMonsterInfoSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("anchorMonsterInfoSingle")
	end
	local timerClass = include("anchorMonsterInfoBase")
	target = timerClass.new(target)
	return target
end)
function anchorMonsterInfoSingle:ctor()
	self.imgIcon = SoraDGetChildByName(self, "Image_icon")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTime:setVisible(false)
	self.txtRefresh = SoraDGetChildByName(self, "Text_refresh_time")
	self.txtRefresh = SoraDCreateTimerLabel(self, self.txtRefresh)
	self.nodeKiller = SoraDGetChildByName(self, "Node_killer")
	self.nodeKiller:setVisible(false)
	self.txtKillerName = SoraDGetChildByName(self, "Text_killer_name")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
end
function anchorMonsterInfoSingle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BOSS_REFRESH_TIME", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BUILD_STATUS", handler(self, self.updateStatus))
end
function anchorMonsterInfoSingle:initView(isMy, pos)
	self.isMy = isMy
	self.uPos = pos
	self.uStatusPos = cc.p(pos.x + 1, pos.y + 1)
	local setIconBg = function(imageHdBg, imageBg, hasHD)
		local bg = hasHD and imageHdBg or imageBg
		self.imgIcon:loadTexture(bg, ccui.TextureResType.plistType)
	end
	local hasHD = worldMapDefine.hasBossHdRes()
	if self.isMy then
		setIconBg(nil, "icon_yjzz_world_boss.png", false)
		self.Text_name:setString("(N)")
	else
		setIconBg(nil, "icon_yjzz_world_boss.png", false)
		self.Text_name:setString("(S)")
	end
	self.imgIcon:ignoreContentAdaptWithSize(true)
	self:initData()
	self:updateStatus()
end
function anchorMonsterInfoSingle:initData()
	self:updateKiller()
	self:updateRefreshTime()
end
function anchorMonsterInfoSingle:updateRefreshTime_imp(time)
	if 0 < time then
		self.nodeTime:setVisible(true)
		self.txtRefresh:beginTime(time)
		self.txtRefresh:setTimeEndListener(function()
			self.nodeTime:setVisible(false)
			self:updateKiller_imp()
		end)
	else
		self.nodeTime:setVisible(false)
		self:updateKiller_imp()
		self.txtRefresh:removeTime()
	end
end
function anchorMonsterInfoSingle:updateRefreshTime()
	local time
	if self.isMy then
		time = remainsWarCtrl:getBossRefreshTime_My()
	else
		time = remainsWarCtrl:getBossRefreshTime_Zjssg()
	end
	self:updateRefreshTime_imp(time)
end
function anchorMonsterInfoSingle:updateKiller_imp(killer)
	local hasKiller = killer and next(killer)
	if hasKiller then
		local name = killer.nickName
		local allianceAbbr = killer.allianceAbb
		if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
			_ENV = nil
			;(nil).abbr = allianceAbbr
			;(nil).name = killer.nickName
			name = i18n("common_text_186", nil)
		end
		if killer.fromKid then
			name = name .. "#" .. tostring(killer.fromKid)
		end
		_ENV = nil
		;(nil).name = name
		self.txtKillerName:setString(i18n("Anchor_text_11", nil))
		self.nodeKiller:setVisible(true)
	else
		self.nodeKiller:setVisible(false)
	end
	self:setIconStateGrey(not hasKiller)
end
function anchorMonsterInfoSingle:updateKiller()
	local killer
	if self.isMy then
		killer = remainsWarCtrl:getBossKiller_My()
	else
		killer = remainsWarCtrl:getBossKiller_Zjssg()
	end
	self:updateKiller_imp(killer)
end
function anchorMonsterInfoSingle:setIconStateGrey(isOpened)
	local state = 1
	if isOpened then
		state = 0
	end
	self.imgIcon:getVirtualRenderer():setState(state)
end
return anchorMonsterInfoSingle
