Select person.stateid as StateAssignedStudentID, CAST(replace(convert(char(10), Birthdate, 101), '/', '') AS CHAR(8)) as DateofBirth, 
Case when CustomStudent.value='ECCPMS' then 289 when customstudent.value='BPMS' then 285
when customstudent.value='HFMS' then 288 when customstudent.value='AAMS' then 279 else NULL end as ReportingDistrict, 
Case when CustomStudent.value='ECCPMS' then 2890113 when customstudent.value='BPMS' then 2850113
when customstudent.value='HFMS' then 2880113 when customstudent.value='AAMS' then 2795113 else NULL end as FacilityCode,
bi.incidentid as LocalIncidentNumber, CAST(replace(convert(char(10), bi.timestamp, 101), '/', '') AS CHAR(8)) as DateofIncident,
LTRIM(RIGHT(CONVERT(VARCHAR(20), bi.timestamp, 100), 7)) as TimeofIncident, cbe.value as Bullying,
--br.personid, be.eventid, bi.timestamp,  
bt.code as IncidentType1,
weaponcode as WeaponInvolvement, be.drugcode as SubstanceInvolvement,
case when br1.relationshiptoschool='4' then 'Y' else 'N' end as VictimOtherStudent,	
case when br1.relationshiptoschool='1' then 'Y' else 'N' end as VictimCertifiedStaff,	
'N' as SubstituteTeacher,
case when br1.relationshiptoschool='3' then 'Y' else 'N' end as VictimOtherStaff,
case when br1.relationshiptoschool='2' then 'Y' else 'N' end as VictimNonSchool,		
case when arrest is null or arrest = '0' then 'N' else 'Y' end  as Arrested,
bi.location as LocationofIncident, 
case when schoolsponsoredevent=1 then 'Y' else 'N' end as SchoolSponsoredActivity,
brest.code as SanctionTypePrimary, 
serviceprovided as EducationProvidedPrimary, schooldaysduration as NumDaysSanctionedPrimary, 
daysservednextyear as NumDaysToCarryoverPrimary,
NULL as SanctionTypeSecondary, NULL as NumDaysSanctionedSecondary,
NULL as NumDatsServedSecondary, NULL as NumDaysToCarryoverSecondary,
cbr.value as PartyTakingAction, person.StudentNumber as DistrictStudentID
from  BehaviorIncident bi inner join BehaviorEvent be on bi.incidentid=be.incidentid
inner join BehaviorRole br on be.eventid=br.eventid
inner join BehaviorType bt on be.typeid=bt.typeid
left join Person on br.personid=person.personid
inner join [identity] i on person.currentidentityid=i.identityid
left join BehaviorResolution reso on br.roleid=reso.roleid
left join BehaviorResType brest on reso.typeid=brest.typeid
left join CustomBehaviorevent cbe on be.eventid=cbe.eventid and  cbe.attributeid=1030
left join CustomBehaviorevent cbe2 on be.eventid=cbe2.eventid and  cbe2.attributeid=601
left join Behaviorrole as br1 on be.eventid=br1.eventid and br1.role='Victim'
left join CustomBehaviorResolution as cbr on reso.resolutionid=cbr.resolutionID and  cbr.attributeid=602
left join CustomStudent on person.personid=customstudent.personid and CustomStudent.attributeid=397
inner join Calendar on bi.calendarid=calendar.calendarid
where brest.name in ('In School Suspension', 'Out of School Suspension', 'Bus Suspension', 'Expelled')
and 
calendar.endyear=2013 
calendar.endyear=2016 
and CustomStudent.value in ('ECCPMS','BPMS','HFMS','AAMS')
order by bi.incidentid