bad example:
```jsx
const UserProfile = ({ userId }) => {
  const [userData, setUserData] = useState(null);

  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then(response => response.json())
      .then(data => setUserData(data));
  }, [userId]);

  return (
    <View>
      <Text>{userData?.name}</Text>
      <Text>{userData?.email}</Text>
    </View>
  );
};
```

good example: 
```jsx
// Custom hook for fetching user data
const useUserData = (userId) => {
  const [userData, setUserData] = useState(null);

  useEffect(() => {
    const fetchUserData = async () => {
      const response = await fetch(`/api/users/${userId}`);
      const data = await response.json();
      setUserData(data);
    };
    fetchUserData();
  }, [userId]);

  return userData;
};

// UserProfile component focuses only on rendering the UI
const UserProfile = ({ userId }) => {
  const userData = useUserData(userId);

  return (
    <View>
      <Text>{userData?.name}</Text>
      <Text>{userData?.email}</Text>
    </View>
  );
};
```