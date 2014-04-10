/*****************************************************************/
/*    NAME: Michael Benjamin, Henrik Schmidt, and John Leonard   */
/*    ORGN: Dept of Mechanical Eng / CSAIL, MIT Cambridge MA     */
/*    FILE: HazardMgr.h                                          */
/*    DATE: Oct 26th 2012                                        */
/*                                                               */
/* This program is free software; you can redistribute it and/or */
/* modify it under the terms of the GNU General Public License   */
/* as published by the Free Software Foundation; either version  */
/* 2 of the License, or (at your option) any later version.      */
/*                                                               */
/* This program is distributed in the hope that it will be       */
/* useful, but WITHOUT ANY WARRANTY; without even the implied    */
/* warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR       */
/* PURPOSE. See the GNU General Public License for more details. */
/*                                                               */
/* You should have received a copy of the GNU General Public     */
/* License along with this program; if not, write to the Free    */
/* Software Foundation, Inc., 59 Temple Place - Suite 330,       */
/* Boston, MA 02111-1307, USA.                                   */
/*****************************************************************/

#ifndef UFLD_HAZARD_MGR_HEADER
#define UFLD_HAZARD_MGR_HEADER

#include "MOOS/libMOOS/Thirdparty/AppCasting/AppCastingMOOSApp.h"
#include "XYHazardSet.h"
#include "XYPolygon.h"
#include <map>

class HazardMgr : public AppCastingMOOSApp
{
 public:
   HazardMgr();
   ~HazardMgr() {};

 protected: // Standard MOOSApp functions to overload
   bool OnNewMail(MOOSMSG_LIST &NewMail);
   bool Iterate();
   bool OnConnectToServer();
   bool OnStartUp();

 protected: // Standard AppCastingMOOSApp function to overload
   //bool buildReport();

 protected: // Registration, Configuration, Mail handling utils
   void registerVariables();
   bool handleMailSensorConfigAck(std::string);
   bool handleMailSensorOptionsSummary(std::string);
   bool handleMailDetectionReport(std::string);
   bool handleMailHazardReport(std::string);
   void handleSendHazardReport();
   void handleReceiveHazardReport(std::string);
   void handleMailReportRequest();
   void handleMailMissionParams(std::string);

 protected:
   void postSensorConfigRequest();
   void postSensorInfoRequest();
   void postHazardSetReport();

 private: // Configuration variables
   double      m_swath_width_desired;
   double      m_pd_desired;
   std::string m_report_name;

 private: // State variables
   bool   m_sensor_config_requested;
   bool   m_sensor_config_set;

   unsigned int m_sensor_config_reqs;
   unsigned int m_sensor_config_acks;

   unsigned int m_sensor_report_reqs;
   unsigned int m_detection_reports;

   unsigned int m_summary_reports;

   double m_swath_width_granted;
   double m_pd_granted;

   XYHazardSet m_hazard_set;
   XYPolygon   m_search_region;

   double      m_transit_path_width;
   std::map<int, std::pair<int, int> > m_classifications;
//   std::map<int, std::pair<int, int> > m_combined_classifications;
   std::map<int, std::pair<int, int> >::const_iterator m_class_iter;
//   std::map<int, std::pair<int, int> >::const_iterator m_class_comb_iter;
   std::vector<int> m_updates;
   int m_repeats;
   bool m_options_set;
   double m_max_time;
   unsigned int m_hazard_reports;
   XYHazardSet m_voted_hazard_set;
   double m_deploy_time;
   double m_rep_time;
   bool m_deployed;
   double m_traverse_time;
   double m_search_time;
   double m_total_time;
   double m_addit_ratio;
   int m_report_count;
   double m_pen_false_alarm;
   double m_pen_missed_hazard;
   double m_vote_multiplier;
   bool m_many_hazard_mode;
   int m_many_hazard_count;
   double m_many_hazard_start_time;
   bool m_many_hazard_reset_time;
   int test;
};

#endif

