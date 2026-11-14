local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisKingdomResultView = class("atlantisKingdomResultView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisKingdomResultView")
	end
	return target
end)
function atlantisKingdomResultView:ctor()
	self:initWidget()
end
function atlantisKingdomResultView:test(...)
	_ENV, _ENV = nil, nil
	;(nil).kid = 1
	;(nil).name = "playerName"
	;(nil).occupyScore = 7777777
	;(nil).personalData, _ENV, (nil).titles, _ENV, (nil).topScorePlayer, (nil).headid = nil, nil, nil, nil, nil, 1401
	local data
	local _ENV, titles
	for i = 1, 4 do
		_ENV = nil
		;(nil).kid = 1
		;(nil).name = "playerName"
		;(nil).score = 7777
		;(nil).headid = 1402
		table.insert(titles, nil)
	end
	data.titles = titles
	self:initData(data)
end
function atlantisKingdomResultView:initWidget(...)
	SoraDCreatAnimation(self.__cname, self._ccsView, true)
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Text_title = SoraDGetChildByName(self.Center_Node, "Text_title")
	self.Text_title:setString(i18n("atlantiswar_text_0176"))
	self.scroll = SoraDGetChildByName(self.Center_Node, "ScrollView_1")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("atlantisBattlePointRankSingle")
	self:fitView()
end
function atlantisKingdomResultView:fitView(...)
	if display.height < 900 then
		self.Center_Node:setScale(0.9)
	end
end
function atlantisKingdomResultView:initData(data)
	self.data = data
	local rankInfo = self.data.campRank or atlantisWarCtrl:getKindomPointRank()
	atlantisWarCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(640, 120), rankInfo, 1, nil)
end
function atlantisKingdomResultView:onExitPanel(...)
	local topScorePlayer = self.data.topScorePlayer
	local titles = self.data.titles
	local personalData = self.data.personalData
	if topScorePlayer and next(topScorePlayer) or titles and next(titles) then
		local panel = SoraDCreatePanel("atlantisResultView")
		panel:initData(self.data)
		panel:show()
	elseif personalData and next(personalData) then
		local panel = SoraDCreatePanel("atlantisPersonResultView")
		panel:initData(personalData)
		panel:show()
	end
end
return atlantisKingdomResultView
