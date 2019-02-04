--Sin レインボー・ドラゴン
function c598988.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c598988.uqfilter,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c598988.spcon)
	e1:SetOperation(c598988.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c598988.descon)
	c:RegisterEffect(e7)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c598988.antarget)
	c:RegisterEffect(e8)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
end
function c598988.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),100236116) then
		return c:IsCode(598988)
	else
		return c:IsSetCard(0x23)
	end
end
function c598988.spfilter(c)
	return c:IsCode(79856792) and c:IsAbleToRemoveAsCost()
end
function c598988.spfilter2(c,tp)
	return c:IsHasEffect(100236115) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c598988.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c598988.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,100236115)==0
		and Duel.IsExistingMatchingCard(c598988.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	return b1 or b2
end
function c598988.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c598988.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,100236115)==0
		and Duel.IsExistingMatchingCard(c598988.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(100236115,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c598988.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
		Duel.RegisterFlagEffect(tp,100236115,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c598988.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	end
end
function c598988.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c598988.antarget(e,c)
	return c~=e:GetHandler()
end
