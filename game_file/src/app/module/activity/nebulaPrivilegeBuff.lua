local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
local _ENV, nebulaPrivilegeBuff = "nebulaPrivilegelRead", "nebulaPrivilegelRead"
function nebulaPrivilegeBuff:initialize()
	if self.buff then
		return
	end
	self.buff, _ENV = self.buff, self.buff
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local allList = nebulaPrivilegelRead.getAllBuffList()
	for title, buffs in pairs(allList) do
		local _ENV, buffList
		for _, buffID in ipairs(buffs.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		self.buff[title] = buffList
	end
end
function nebulaPrivilegeBuff:getTitleBuff(titles, buffType)
	local value = 0
	for title in pairs(titles) do
		if buffType and self.buff and self.buff[title] then
			value = value + (self.buff[title][buffType] or 0)
		end
	end
	return value
end
function nebulaPrivilegeBuff:notifyBuffChange(titles)
	if not titles or not self.buff then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	for title in pairs(titles) do
		local buffList = self.buff[title]
		for buffType, _ in pairs(buffList) do
			buffCtrl:dispatchBuffEvent(buffType, gBuffSource.NEBULA_PRIVILEGE)
		end
	end
end
nebulaPrivilegeBuff:initialize()
return nebulaPrivilegeBuff
