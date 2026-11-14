local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisBattlePointKindom = class("atlantisBattlePointKindom", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
function atlantisBattlePointKindom:ctor(properties)
	self.rankInfo, _ENV, self.selfRankInfo, _ENV = nil, nil, nil, nil
	self.scrollRank = SoraDGetChildByName(self, "Size_ScrollView")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("atlantisBattlePointRankSingle")
	self.textNoRecrod = SoraDGetChildByName(self, "Center_Text_noRecrod")
	self.textNoRecrod:setString(i18n("common_text_927"))
end
function atlantisBattlePointKindom:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_POINT_RANK", handler(self, self.msgCallBack))
end
function atlantisBattlePointKindom:initWithKid(kid)
	self.kid = kid
	if self.kid then
		SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_WARDATA", handler(self, self.msgRefreshWarData))
	end
end
function atlantisBattlePointKindom:updateScroll()
	if self.rankInfo and next(self.rankInfo) then
		self.scrollRank:setVisible(true)
		_ENV = nil
		;(nil).scroll = self.scrollRank
		;(nil).view = self
		self.scrollRank:updateScrollView(cc.size(640, 120), self.rankInfo, 1, nil)
		self.scrollRank:jumpToTop()
		self.textNoRecrod:setVisible(false)
	else
		self.scrollRank:setVisible(false)
		self.textNoRecrod:setVisible(true)
	end
end
function atlantisBattlePointKindom:requestMore()
	if self.kid then
		SoraDShowLoading(self)
		atlantisWarCtrl:reqWarData(-1)
	else
		SoraDShowLoading(self)
		atlantisWarCtrl:reqWarPeopleNum()
	end
end
function atlantisBattlePointKindom:msgCallBack(target, data)
	if data.key == "reqWarPeopleNumRsp" and self:isVisible() then
		SoraDCloseLoading(self)
		if tonumber(data.err) ~= 0 then
			return
		end
		self.rankInfo = atlantisWarCtrl:getKindomPointRank()
		dump(self.rankInfo, "rankInfo")
		self:updateScroll()
	end
end
function atlantisBattlePointKindom:msgRefreshWarData(target, data)
	SoraDCloseLoading(self)
	self.rankInfo = atlantisWarCtrl:getKindomPointRank()
	self:updateScroll()
end
return atlantisBattlePointKindom
