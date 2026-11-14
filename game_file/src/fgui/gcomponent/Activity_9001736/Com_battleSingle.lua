local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_battleSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_battleSingle", Com_battleSingle)
function Com_battleSingle:onInit()
	self.fields.Button_battle:setTitle(i18n("football_match_text_015"))
	self.fields.Button_battle:addClickListener(handler(self, self.onClick_Button_battle))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_battleSingle:onShow()
end
function Com_battleSingle:onClick_Button_battle(context)
	SoraDPlaySound()
	local leftTimes = activity_9001736_Ctrl:getChallengeLeftTimes()
	if leftTimes <= 0 then
		SoraDShowMsgTip(i18n("football_match_text_089"))
		return
	end
	SoraDShowLoading()
	activity_9001736_Ctrl:reqBattle(self.data.uid)
end
function Com_battleSingle:initData(data)
	self.data = data
	_ENV = nil
	;(nil).rank = data.rank
	;(nil).uid = data.uid
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	local nameStr = textParser.formatPlayerName(data.allianceAbbr, data.name, data.kid)
	self.fields.Text_name:setString(nameStr)
	local powerStr = string.formatnumberthousands(data.power or 0)
	_ENV = nil
	;(nil).num = powerStr
	self.fields.Text_power:setString(i18n("football_match_text_021", nil))
	local scoreStr = string.formatnumberthousands(data.score or 0)
	_ENV = i18n("football_match_text_021", nil)
	_ENV, _ENV, i18n("football_match_text_021", nil).score = i18n("football_match_text_021", nil)
	i18n("football_match_text_021", nil).score, i18n("football_match_text_021", nil).color = i18n("football_match_text_021", nil)
	scoreStr = i18n_html("krone_text_15", i18n("football_match_text_021", nil))
	self.fields.Text_score:setString(scoreStr)
end
return Com_battleSingle
