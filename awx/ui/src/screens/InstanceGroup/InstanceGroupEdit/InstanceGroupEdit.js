import React, { useState } from 'react';
import { useHistory } from 'react-router-dom';

import { CardBody } from 'components/Card';
import { InstanceGroupsAPI } from 'api';
import InstanceGroupForm from '../shared/InstanceGroupForm';

function InstanceGroupEdit({
  instanceGroup,
  defaultControlPlane,
  defaultExecution,
}) {
  const history = useHistory();
  const [submitError, setSubmitError] = useState(null);
  const detailsUrl = `/instance_groups/${instanceGroup.id}/details`;

  const handleSubmit = async (values) => {
    try {
      await InstanceGroupsAPI.update(instanceGroup.id, values);
      history.push(detailsUrl);
    } catch (error) {
      setSubmitError(error);
    }
  };

  const handleCancel = () => {
    history.push(detailsUrl);
  };

  return (
    <CardBody>
      <InstanceGroupForm
        instanceGroup={instanceGroup}
        defaultControlPlane={defaultControlPlane}
        defaultExecution={defaultExecution}
        onSubmit={handleSubmit}
        submitError={submitError}
        onCancel={handleCancel}
      />
    </CardBody>
  );
}

export default InstanceGroupEdit;
