import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from "inferno";
import { useBackend, useLocalState } from '../backend';
import { Input, Button, Flex, Divider, Collapsible, Icon, NumberInput, Table } from '../components';
import { Window } from '../layouts';

const redFont = {
  color: "red",
};
/**
 * Filters the list of cultists and returns a set of rows that will be used in the
 * Cultist list table
 */
const filterCultists = data => {
  const {
    searchKey, searchFilters,
    maxHealth, cultists_keys,
    cultist_vitals, cultist_info,
  } = data;
  const cultist_entries = [];

  cultists_keys.map((key, i) => {
    const real_name = key.real_name.toString();
    let entry = {
      real_name: real_name,
      name: cultist_info[real_name].name,
      assigned_job: cultist_info[real_name].assigned_job,
      location: cultist_vitals[real_name].area,
      health: cultist_vitals[real_name].health,
      ref: cultist_info[real_name].ref,
      is_ssd: cultist_vitals[real_name].is_ssd,
      is_leader: key.is_leader,
      is_eminence: key.is_eminence,
    };
    cultist_entries.push(entry);
  });

  const filter_params = {
    searchKey: searchKey,
    searchFilters: searchFilters,
    maxHealth: maxHealth,
  };
  const filtered = cultist_entries.filter(getFilter(filter_params));

  return filtered;
};

/**
 * Creates a filter function based on the search key (passed to the search bar),
 * the categories selected to be searched through, and the max health filter
 */
const getFilter = data => {
  const {
    searchKey, searchFilters, maxHealth,
  } = data;
  const textSearch = createSearch(searchKey);

  return entry => {
    if (entry.health > maxHealth) {
      return false;
    }

    let hasFilter = false;
    for (let filter in searchFilters) {
      if (searchFilters[filter]) {
        hasFilter = true;
        if (textSearch(entry[filter])) {
          return true;
        }
      }
    }

    return hasFilter ? false : true;
  };
};

export const StatusBar = (props, context) => {
  const { data } = useBackend(context);
  const { cult_name } = data;

  return (
    <Window
      title={cult_name + " Status"}
      theme="cult_status"
      resizable
      width={600}
      height={680}
    >
      <Window.Content scrollable>
        <CultCollapsible
          title="General Cult Information"
        >
          <GeneralInformation />
        </CultCollapsible>
        <Divider />
        <CultCollapsible
          title="Acolytes List"
        >
          <CultList />
        </CultCollapsible>
      </Window.Content>
    </Window>
  );
};

const GeneralInformation = (props, context) => {
  const { data } = useBackend(context);
  const {
    total_cultists,
    eminence_location,
  } = data;

  return (
    <Flex
      direction="column"
      align="center"
    >
      <Flex.Item
        textAlign="center"
      >
        <h3 className="whiteTitle">The Eminence at:</h3>
        <h1 className="whiteTitle">{eminence_location}</h1>
      </Flex.Item>
      <Flex.Item
        mt={1}
      >
        <i>Total acolytes: {total_cultists}</i>
      </Flex.Item>
    </Flex>
  );
};

const CultList = (props, context) => {
  const { act, data } = useBackend(context);
  const [searchKey, setSearchKey] = useLocalState(context, 'searchKey', '');
  const [searchFilters, setSearchFilters] = useLocalState(context, 'searchFilters', { name: true, assigned_job: true, location: true });
  const [maxHealth, setMaxHealth] = useLocalState(context, 'maxHealth', 100);
  const {
    cultists_keys, cultist_vitals,
    cultist_info, user_ref,
    cult_color, is_in_ovi,
  } = data;
  const cultist_entries = filterCultists({
    searchKey: searchKey,
    searchFilters: searchFilters,
    maxHealth: maxHealth,
    cultists_keys: cultists_keys,
    cultist_vitals: cultist_vitals,
    cultist_info: cultist_info,
  });

  return (
    <Flex
      direction="column"
    >
      <Flex.Item mb={1}>
        <Flex
          align="baseline"
        >
          <Flex.Item width="100px">
            Search Filters:
          </Flex.Item>
          <Flex.Item>
            <Button.Checkbox
              inline
              content="Name"
              checked={searchFilters.name}
              backgroundColor={searchFilters.name && cult_color}
              onClick={() => setSearchFilters({
                ...searchFilters,
                name: !searchFilters.name,
              })}
            />
            <Button.Checkbox
              inline
              content="Job"
              checked={searchFilters.assigned_job}
              backgroundColor={searchFilters.assigned_job && cult_color}
              onClick={() => setSearchFilters({
                ...searchFilters,
                assigned_job: !searchFilters.assigned_job,
              })}
            />
            <Button.Checkbox
              inline
              content="Location"
              checked={searchFilters.location}
              backgroundColor={searchFilters.location && cult_color}
              onClick={() => setSearchFilters({
                ...searchFilters,
                location: !searchFilters.location,
              })}
            />
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item mb={1}>
        <Flex
          align="baseline"
        >
          <Flex.Item width="100px">
            Max Health:
          </Flex.Item>
          <Flex.Item>
            <NumberInput
              animated
              width="40px"
              step={1}
              stepPixelSize={5}
              value={maxHealth}
              minValue={0}
              maxValue={100}
              onChange={(_, value) => setMaxHealth(value)}
            />
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item mb={2}>
        <Input
          fluid={1}
          placeholder="Search..."
          onInput={(_, value) => setSearchKey(value)}
        />
      </Flex.Item>

      <Table className="cultist_list">
        <Table.Row header className="cultistListRow">
          <Table.Cell width="5%" className="noPadCell" />
          <Table.Cell>Name</Table.Cell>
          <Table.Cell width="15%">Job</Table.Cell>
          <Table.Cell>Location</Table.Cell>
          <Table.Cell width="75px">Health</Table.Cell>
          <Table.Cell width="100px" />
        </Table.Row>

        {cultist_entries.map((entry, i) => (
          <Table.Row
            key={i}
            className={classes([
              entry.is_ssd ? "ssdRow" : "",
              "cultistListRow",
            ])}
          >
            <Table.Cell className="noPadCell">
              <StatusIcon entry={entry} />
            </Table.Cell>
            <Table.Cell>{entry.name}</Table.Cell>
            <Table.Cell>{entry.assigned_job}</Table.Cell>
            <Table.Cell>{entry.location}</Table.Cell>
            <Table.Cell>
              {entry.health < 30
                ? <b style={redFont}>{entry.health}%</b>
                : <Fragment>{entry.health}%</Fragment>}
            </Table.Cell>
            <Table.Cell className="noPadCell" textAlign="center">
              {entry.ref !== user_ref && (
                <Flex
                  unselectable="on"
                  wrap="wrap"
                  className="actionButton"
                  align="center"
                  justify="space-around"
                  inline
                >
                  <Flex.Item>
                    <Button
                      content="Watch"
                      color="cultist"
                      onClick={
                        () => act("overwatch", {
                          target_ref: entry.ref,
                        })
                      }
                    />
                  </Flex.Item>
                  {!!is_in_ovi && (
                    <QueenOviButtons target_ref={entry.ref} />
                  )}
                </Flex>
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Flex>
  );
};

const StatusIcon = (props, context) => {
  const { entry } = props;
  const { is_ssd, is_leader, is_eminence } = entry;

  if (is_ssd) {
    return <div unselectable="on" className="ssdIcon" />;
  } else if (is_leader || is_eminence) {
    return (
      <div unselectable="on" className="leaderIcon">
        <Icon name="star" ml={0.2} />
      </div>
    );
  }
};

const CultCollapsible = (props, context) => {
  const { data } = useBackend(context);
  const { title, children } = props;
  const { cult_color } = data;

  return (
    <Collapsible
      title={title}
      backgroundColor={!!cult_color && cult_color}
      color={!cult_color && "cultist"}
      open
    >
      {children}
    </Collapsible>
  );
};

const QueenOviButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const { target_ref } = props;

  return (
    <Fragment>
      <Flex.Item>
        <Button
          content="Heal"
          color="green"
          onClick={
            () => act("heal", {
              target_ref: target_ref,
            })
          }
        />
      </Flex.Item>
      <Flex.Item>
        <Button
          content="Give Plasma"
          color="blue"
          onClick={
            () => act("give_plasma", {
              target_ref: target_ref,
            })
          }
        />
      </Flex.Item>
    </Fragment>
  );
};
