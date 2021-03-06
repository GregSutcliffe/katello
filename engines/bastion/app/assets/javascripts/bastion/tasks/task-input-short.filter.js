/**
 Copyright 2014 Red Hat, Inc.

 This software is licensed to you under the GNU General Public
 License as published by the Free Software Foundation; either version
 2 of the License (GPLv2) or (at your option) any later version.
 There is NO WARRANTY for this software, express or implied,
 including the implied warranties of MERCHANTABILITY,
 NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 have received a copy of GPLv2 along with this software; if not, see
 http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 **/

/**
 * @ngdoc filter
 * @name  Bastion.tasks.filter:taskInputCompile
 *
 * @description
 *   Produces the shortest possible version of humanized input of a
 *   task, used for list of recent user tasks.
 */

angular.module('Bastion.tasks')
    .filter('taskInputShort', function () {
        return function (humanizedTaskInput) {
            if (_.isString(humanizedTaskInput)) {
                return humanizedTaskInput;
            }
            return _.first(humanizedTaskInput, 1);
        };
    });
