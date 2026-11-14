local baseComponent = require("fgui.base.baseComponent")
local Com_FP_chat = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_chat", Com_FP_chat)
local foreignPavilionRead = include("foreignPavilionRead")
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
function Com_FP_chat:onInit()
	if not SoraDFIsRA() then
		self.fields.bg:fix()
	end
end
function Com_FP_chat:onShow()
end
function Com_FP_chat:setChat(type1, type2, lastTime, endCallback)
	local talkCfgs
	if type1 ~= 5 then
		talkCfgs = foreignPavilionRead:getTalk(type1, type2)
	else
		local isPoint = exoticPavilionCtrl:getIsGetChatPoint()
		talkCfgs = foreignPavilionRead:getPointTalk(type2, isPoint)
	end
	if not talkCfgs or #talkCfgs == 0 then
		self:setVisible(false)
		if endCallback then
			endCallback()
		end
		return
	end
	local idx = math.random(#talkCfgs)
	local talkCfg = talkCfgs[idx]
	if talkCfg.probability == 1 then
		exoticPavilionCtrl:reqEPCatIncrIntimacy()
		exoticPavilionCtrl:resetGetChatPointCount()
	end
	if talkCfg.sound and talkCfg.sound ~= "" then
		SoraDPlaySound("foreignPavilion", talkCfg.sound)
	end
	self:showChat(i18n(talkCfg.key), lastTime, endCallback)
end
function Com_FP_chat:showChat(chatStr, lastTime, endCallback)
	self:setVisible(true)
	self.fields.text_chat:setAutoSize(fgui.AutoSizeType.BOTH)
	self.fields.text_chat:setString(chatStr)
	if self.fields.text_chat:getSize().width >= 176 then
		self.fields.text_chat:setSize(cc.size(176, 0))
		self.fields.text_chat:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
	self:stopAllActions()
	if lastTime == -1 then
		return
	end
	lastTime = lastTime and lastTime or 3
	self:runAction(ffa.seq(ffa.delay(lastTime), ffa.callFunc(function()
		self:setVisible(false)
		if endCallback then
			endCallback()
		end
	end)))
end
function Com_FP_chat:setChatTextOnly(chatStr)
	self:setVisible(true)
	self.fields.text_chat:setAutoSize(fgui.AutoSizeType.BOTH)
	self.fields.text_chat:setString(chatStr)
	if self.fields.text_chat:getSize().width >= 176 then
		self.fields.text_chat:setSize(cc.size(176, 0))
		self.fields.text_chat:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
end
return Com_FP_chat
